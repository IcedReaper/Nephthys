CREATE SEQUENCE seq_nephthys_pageVersion_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE nephthys_pageVersion
(
  pageVersionid integer NOT NULL DEFAULT nextval('seq_nephthys_pageVersion_id'::regclass),
  pageId integer NOT NULL,
  parentPageId integer DEFAULT NULL,
  version character varying(25),
  linkText character varying(30) NOT NULL,
  link character varying(100) NOT NULL,
  title character varying(160),
  description character varying(160),
  content text,
  sortOrder integer,
  useDynamicSuffixes boolean NOT NULL DEFAULT true,
  region character varying(25) DEFAULT 'header',
  pageStatusId integer,
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),

  CONSTRAINT PK_nephthys_pageVersion_id PRIMARY KEY (pageVersionid),
  CONSTRAINT FK_nephthys_pageVersion_pageId FOREIGN KEY (pageId) REFERENCES nephthys_page (pageId) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_nephthys_pageVersion_parentPageId FOREIGN KEY (parentPageId) REFERENCES nephthys_page (pageid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_nephthys_pageVersion_prevId FOREIGN KEY (prevPageVersionId) REFERENCES nephthys_pageVersion (pageVersionid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_nephthys_pageVersion_nextId FOREIGN KEY (nextPageVersionId) REFERENCES nephthys_pageVersion (pageVersionid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT UK_nephthys_pageVersion_version UNIQUE (pageId, version)
)
WITH (
    OIDS = FALSE
);

CREATE INDEX FKI_nephthys_pageVersion_parentPageid ON nephthys_pageVersion(parentPageid);
CREATE INDEX FKI_nephthys_pageVersion_prevPageVersionId ON nephthys_pageVersion(prevPageVersionId);
CREATE INDEX FKI_nephthys_pageVersion_nextPageVersionId ON nephthys_pageVersion(nextPageVersionId);
CREATE INDEX FKI_nephthys_pageVersion_creatorUserId ON nephthys_pageVersion(creatorUserId);
CREATE INDEX FKI_nephthys_pageVersion_lastEditorUserId ON nephthys_pageVersion(lastEditorUserId);
CREATE INDEX IDX_nephthys_pageVersion_active ON nephthys_pageVersion(active);
CREATE INDEX IDX_nephthys_pageVersion_sortOrder ON nephthys_pageVersion(sortOrder);
CREATE INDEX IDX_nephthys_pageVersion_defaultParam ON nephthys_pageVersion(pageId, region, active, pageStatusId);


CREATE SEQUENCE seq_nephthys_pageHierarchy_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE nephthys_pageHierarchy
(
    pageHierarchyId integer NOT NULL DEFAULT nextval('seq_nephthys_pageHierarchy_id'::regclass),
    pageId integer NOT NULL,
    sortOrder integer NOT NULL,
    region character varying(25) DEFAULT 'header',
    
    CONSTRAINT PK_nephthys_pageHierarchy_id PRIMARY KEY (pageHierarchyId),
    CONSTRAINT FK_nephthys_pageHierarchy_pageId FOREIGN KEY (pageId) REFERENCES nephthys_page (pageId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT UK_nephthys_pageHierarchy_regionSortOrder UNIQUE (sortOrder, region)
)
WITH (
    OIDS = FALSE
);

INSERT INTO nephthys_pageVersion 
(
  pageId,
  parentPageId,
  version,
  linktext,
  link,
  title,
  description,
  content,
  sortOrder,
  useDynamicSuffixes,
  active,
  region,
  pageStatusId,
  creatorUserId,
  creationDate,
  lastEditorUserId,
  lastEditDate
)
SELECT 
  pageId,
  NULL,
  '1.0',
  linktext,
  link,
  title,
  description,
  content,
  sortOrder,
  useDynamicSuffixes,
  active,
  region,
  pageStatusId,
  creatorUserId,
  creationDate,
  lastEditorUserId,
  lastEditDate
FROM nephthys_page;

INSERT INTO nephthys_pageHierarchy
(
  pageId,
  sortOrder,
  region
)
SELECT
  pageId,
  sortOrder,
  region
FROM nephthys_page;

ALTER TABLE nephthys_page DROP COLUMN parentId;
ALTER TABLE nephthys_page DROP COLUMN linktext;
ALTER TABLE nephthys_page DROP COLUMN link;
ALTER TABLE nephthys_page DROP COLUMN title;
ALTER TABLE nephthys_page DROP COLUMN description;
ALTER TABLE nephthys_page DROP COLUMN content;
ALTER TABLE nephthys_page DROP COLUMN sortOrder;
ALTER TABLE nephthys_page DROP COLUMN useDynamicSuffixes;
ALTER TABLE nephthys_page DROP COLUMN active;
ALTER TABLE nephthys_page DROP COLUMN region;
ALTER TABLE nephthys_page DROP COLUMN lastEditorUserId;
ALTER TABLE nephthys_page DROP COLUMN lastEditDate;


GRANT SELECT ON TABLE nephthys_pageVersion TO nephthys_user;
GRANT SELECT ON TABLE nephthys_pageHierarchy TO nephthys_user;

ALTER TABLE nephthys_page ADD COLUMN actualVersion character varying(25);
CREATE INDEX IDX_nephthys_page_version ON nephthys_page(actualVersion);

ALTER TABLE nephthys_pageStatus ADD COLUMN sortOrder integer NOT NULL;
ALTER TABLE nephthys_pageStatus ADD CONSTRAINT UK_nephthys_pageStatus_sortOrder UNIQUE (sortOrder);
ALTER TABLE nephthys_pageStatus ADD COLUMN editable boolean NOT NULL DEFAULT FALSE;



----------------------------------
-- WORKFLOW
----------------------------------

CREATE SEQUENCE seq_nephthys_pageStatusFlow_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;

CREATE TABLE nephthys_pageStatusFlow
(
    pageStatusFlowId integer NOT NULL DEFAULT nextval('seq_nephthys_pageStatusFlow_id'::regclass),
    pageStatusId integer NOT NULL,
    nextPageStatusId integer DEFAULT NULL,
    active boolean NOT NULL DEFAULT true,
    
    CONSTRAINT PK_nephthys_pageStatusFlow_Id PRIMARY KEY (pageStatusFlowId),
    CONSTRAINT FK_nephthys_pageStatusFlow_pageStatusId     FOREIGN KEY (pageStatusId)     REFERENCES nephthys_pageStatus (pageStatusId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageStatusFlow_nextPageStatusId FOREIGN KEY (nextPageStatusId) REFERENCES nephthys_pageStatus (pageStatusId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT UK_nephthys_pageStatusFlow_statusCombination UNIQUE (pageStatusId, nextPageStatusId)
)
WITH
(
    OIDS = FALSE
);

CREATE INDEX FKI_nephthys_pageStatusFlow_pageStatusId ON nephthys_pageStatusFlow(pageStatusId);
CREATE INDEX FKI_nephthys_pageStatusFlow_nextPageStatusId ON nephthys_pageStatusFlow(nextPageStatusId);

/*
Status:
1   "In Erstellung"
3   "In Bearbeitung"
4   "Online"
5   "Offline"
6   "In Rewiew"
7   "Gelöscht"


flow
1 1 3 1 true
2 1 6 1 true
3 1 7 1 true
4 3 6 1 true
5 3 7 1 true
6 6 4 1 true
7 6 7 1 true
8 4 5 1 true
9 5 7 1 true
*/

/*
SELECT 
flow.pageStatusFlowId, actual.name von, flow.name nach
FROM nephthys_pageStatus actual
LEFT OUTER JOIN 
(SELECT f.pageStatusFlowId, f.pageStatusId, n.name 
   FROM nephthys_pageStatusFlow f
   INNER JOIN nephthys_pageStatus n ON f.nextPageStatusId = n.pageStatusId) flow ON actual.pageStatusId = flow.pageStatusId
 WHERE actual.pageStatusId = 3
*/

ALTER TABLE nephthys_pageStatus DROP COLUMN sortOrder;




CREATE SEQUENCE seq_nephthys_pageRequiredApproval_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;

CREATE TABLE nephthys_pageRequiredApproval
(
    pageRequiredApprovalId integer NOT NULL DEFAULT nextval('seq_nephthys_pageRequiredApproval_id'::regclass),
    pageStatusFlowId integer NOT NULL,
    userId integer NOT NULL,
    sortOrder integer NOT NULL DEFAULT 1,
    
    
    CONSTRAINT PK_nephthys_pageRequiredApproval_Id PRIMARY KEY (pageRequiredApprovalId),
    CONSTRAINT FK_nephthys_pageRequiredApproval_psfId  FOREIGN KEY (pageStatusFlowId) REFERENCES nephthys_pageStatusFlow (pageStatusFlowId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageRequiredApproval_userId FOREIGN KEY (userId)           REFERENCES nephthys_user (userId)                     ON UPDATE NO ACTION ON DELETE CASCADE,
    
    CONSTRAINT UK_nephthys_pageRequiredApproval_psfUser UNIQUE (pageStatusFlowId, userId),
    CONSTRAINT UK_nephthys_pageRequiredApproval_psfSo   UNIQUE (pageStatusFlowId, sortOrder)
)
WITH
(
    OIDS = FALSE
);

CREATE INDEX FKI_nephthys_pageRequiredApproval_pageStatusFlowId ON nephthys_pageRequiredApproval(pageStatusFlowId);
CREATE INDEX FKI_nephthys_pageRequiredApproval_userId           ON nephthys_pageRequiredApproval(userId);
CREATE INDEX IDX_nephthys_pageRequiredApproval_psfUserSo        ON nephthys_pageRequiredApproval(pageStatusFlowId, userId, sortOrder);



CREATE SEQUENCE seq_nephthys_pageApproval_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE nephthys_pageApproval
(
    pageApprovalId integer NOT NULL DEFAULT nextval('seq_nephthys_pageApproval_id'::regclass),
    pageStatusFlowId integer NOT NULL,
    userId integer NOT NULL,
    sortOrder integer NOT NULL DEFAULT 1,
    approvalDate timestamp with time zone DEFAULT NULL,
    
    CONSTRAINT PK_nephthys_pageApproval_Id     PRIMARY KEY (pageApprovalId),
    CONSTRAINT FK_nephthys_pageApproval_psfId  FOREIGN KEY (pageStatusFlowId) REFERENCES nephthys_pageStatusFlow (pageStatusFlowId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageApproval_userId FOREIGN KEY (userId)           REFERENCES nephthys_user (userId)                     ON UPDATE NO ACTION ON DELETE CASCADE,
    
    CONSTRAINT UK_nephthys_pageApproval_psfUser UNIQUE (pageStatusFlowId, userId),
    CONSTRAINT UK_nephthys_pageApproval_psfSo   UNIQUE (pageStatusFlowId, sortOrder)
)
WITH
(
    OIDS = FALSE
);

CREATE INDEX FKI_nephthys_pageApproval_pageStatusFlowId ON nephthys_pageApproval(pageStatusFlowId);
CREATE INDEX FKI_nephthys_pageApproval_userId           ON nephthys_pageApproval(userId);
CREATE INDEX IDX_nephthys_pageApproval_psfUserSo        ON nephthys_pageApproval(pageStatusFlowId, userId, sortOrder);


alter table nephthys_page rename column actualversion to av;
alter table nephthys_page add column pageVersionId integer;

update nephthys_page p set pageVersionId = (SELECT pv.pageVersionId FROM nephthys_pageVersion pv WHERE p.av = pv.version AND p.pageId = pv.pageId);

alter table nephthys_page drop column av;
alter table nephthys_page alter column pageVersionId SET NOT NULL;

alter table nephthys_pageVersion add column majorVersion integer;
alter table nephthys_pageVersion add column minorVersion integer;

update nephthys_pageVersion set majorVersion = 1;
update nephthys_pageVersion pv set minorVersion = cast(substring(pv.version from 3 for 1) as integer);

alter table nephthys_pageVersion drop column version;

alter table nephthys_pageVersion alter column minorVersion SET NOT NULL;
alter table nephthys_pageVersion alter column majorVersion SET NOT NULL;

alter table nephthys_page add constraint FK_nephthys_page_pageVersionId foreign key (pageVersionId) references nephthys_pageVersion (pageVersionId) ON UPDATE NO ACTION ON DELETE CASCADE;
create index fki_nephthys_page_pageVersionId ON nephthys_page (pageVersionId);

alter table nephthys_pageVersion add constraint UK_nephthys_pageVersion_version UNIQUE (pageId, majorVersion, minorVersion);

alter table nephthys_pageStatus add column startStatus boolean default false;


// 31.05.2016
alter table nephthys_pageVersion drop column prevPageVersionId;
alter table nephthys_pageVersion drop column nextPageVersionId;

alter table nephthys_pageStatus add column endStatus boolean default false;