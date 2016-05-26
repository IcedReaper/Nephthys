CREATE SEQUENCE seq_nephthys_pageVersion_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_page_id OWNER TO nephthys_admin;

CREATE TABLE nephthys_pageVersion
(
  pageVersionid integer NOT NULL DEFAULT nextval('seq_nephthys_pageVersion_id'::regclass),
  pageId integer NOT NULL,
  parentPageId integer DEFAULT NULL,
  prevPageVersionId integer DEFAULT NULL,
  nextPageVersionId integer DEFAULT NULL,
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
ALTER SEQUENCE seq_nephthys_pageHierarchy_id OWNER TO nephthys_admin;

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