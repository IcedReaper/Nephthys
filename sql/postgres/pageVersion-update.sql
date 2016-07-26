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



/* TO BE DISCUSSED
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
*/


CREATE SEQUENCE seq_nephthys_pageApproval_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE nephthys_pageApproval
(
    pageApprovalId integer NOT NULL DEFAULT nextval('seq_nephthys_pageApproval_id'::regclass),
    pageVersionId integer NOT NULL,
    oldPageStatusId integer, -- for the first the old is null
    newPageStatusId integer NOT NULL,
    userId integer NOT NULL,
    approvalDate timestamp with time zone NOT NULL DEFAULT now(),
    
    CONSTRAINT PK_nephthys_pageApproval_Id     PRIMARY KEY (pageApprovalId),
    CONSTRAINT FK_nephthys_pageApproval_pvId   FOREIGN KEY (pageVersionId)   REFERENCES nephthys_pageVersion (pageVersionId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageApproval_opsId  FOREIGN KEY (oldPageStatusId) REFERENCES nephthys_pageStatus (pageStatusId)   ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageApproval_npsId  FOREIGN KEY (newPageStatusId) REFERENCES nephthys_pageStatus (pageStatusId)   ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageApproval_userId FOREIGN KEY (userId)          REFERENCES nephthys_user (userId)               ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH
(
    OIDS = FALSE
);

CREATE INDEX FKI_nephthys_pageApproval_oldPageStatusId ON nephthys_pageApproval(oldPageStatusId);
CREATE INDEX FKI_nephthys_pageApproval_newPageStatusId ON nephthys_pageApproval(newPageStatusId);
CREATE INDEX FKI_nephthys_pageApproval_userId          ON nephthys_pageApproval(userId);


alter table nephthys_page rename column actualversion to av;
alter table nephthys_page add column pageVersionId integer;

update nephthys_page p set pageVersionId = (SELECT pv.pageVersionId FROM nephthys_pageVersion pv WHERE p.av = pv.version AND p.pageId = pv.pageId);

alter table nephthys_page drop column av;
alter table nephthys_page alter column pageVersionId DROP NOT NULL; -- when the page is saved for the first time the pageVersion will not exist as the pageVersion needs an pageId which otherwise will not exist

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

alter table nephthys_pageVersion drop column prevPageVersionId;
alter table nephthys_pageVersion drop column nextPageVersionId;

alter table nephthys_pageStatus add column endStatus boolean default false;

alter table nephthys_pageStatus add column deleteable boolean default false;
comment on column nephthys_pageStatus.deleteable is 'If this is true, pages within this status can be permanently deleted';


alter table nephthys_pageHierarchy add column parentPageId integer DEFAULT NULL;
alter table nephthys_pageHierarchy add constraint FK_nephthys_pageHierarchy_parentPageId foreign key (parentPageId) references nephthys_page (pageId) ON UPDATE NO ACTION ON DELETE CASCADE;
create index fki_nephthys_page_pageHierarchy_parentPageId ON nephthys_pageHierarchy (parentPageId);



-- 160603 - 15:00
-- page hierarchy changes
alter table nephthys_pageVersion drop column sortOrder;
alter table nephthys_pageVersion drop column parentPageId;
alter table nephthys_pageVersion drop column region;

alter table nephthys_page drop column pageStatusId;


drop table nephthys_pageHierarchy;
drop sequence seq_nephthys_pageHierarchy_id;

CREATE SEQUENCE seq_nephthys_pageHierarchyVersion_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;

CREATE TABLE nephthys_pageHierarchyVersion
(
    pageHierarchyVersionId integer NOT NULL DEFAULT nextval('seq_nephthys_pageHierarchyVersion_id'::regclass),
    pageStatusId integer NOT NULL,
    creatorUserId integer NOT NULL,
    creationDate timestamp with time zone NOT NULL DEFAULT now(),
    
    CONSTRAINT PK_nephthys_pageHierarchyVersion_id PRIMARY KEY (pageHierarchyVersionId),
    CONSTRAINT FK_nephthys_pageHierarchyVersion_pageStatusId FOREIGN KEY (pageStatusId)  REFERENCES nephthys_pageStatus (pageStatusId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT UK_nephthys_pageHierarchyVersion_userId       FOREIGN KEY (creatorUserId) REFERENCES nephthys_user (userId)             ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
);

CREATE INDEX FKI_nephthys_pageHierarchyVersion_pageStatusId ON nephthys_pageHierarchyVersion (pageStatusId);
CREATE INDEX FKI_nephthys_pageHierarchyVersion_userId       ON nephthys_pageHierarchyVersion (creatorUserId);


CREATE SEQUENCE seq_nephthys_pageHierarchy_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE nephthys_pageHierarchy
(
    pageHierarchyId integer NOT NULL DEFAULT nextval('seq_nephthys_pageHierarchy_id'::regclass),
    pageHierarchyVersionId integer NOT NULL,
    region character varying(25) DEFAULT 'header',
    pageId integer NOT NULL,
    parentPageId integer DEFAULT NULL,
    sortOrder integer NOT NULL,
    
    CONSTRAINT PK_nephthys_pageHierarchy_id           PRIMARY KEY (pageHierarchyId),
    CONSTRAINT FK_nephthys_pageHierarchy_versionId    FOREIGN KEY (pageHierarchyVersionId) REFERENCES nephthys_pageHierarchyVersion (pageHierarchyVersionId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageHierarchy_pageId       FOREIGN KEY (pageId)                 REFERENCES nephthys_page (pageId)                                 ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageHierarchy_parentPageId FOREIGN KEY (parentPageId)           REFERENCES nephthys_page (pageId)                                 ON UPDATE NO ACTION ON DELETE CASCADE,
    
    CONSTRAINT UK_nephthys_pageHierarchy_regionParentSortOrder UNIQUE (pageHierarchyVersionId, region, parentPageId, sortOrder),
    CONSTRAINT UK_nephthys_pageHierarchy_pageId                UNIQUE (pageHierarchyVersionId, pageId)
)
WITH (
    OIDS = FALSE
);


CREATE INDEX FKI_nephthys_pageHierarchy_versionId    ON nephthys_pageHierarchy (pageHierarchyVersionId);
CREATE INDEX FKI_nephthys_pageHierarchy_pageId       ON nephthys_pageHierarchy (pageId);
CREATE INDEX FKI_nephthys_pageHierarchy_parentPageId ON nephthys_pageHierarchy (parentPageId);
CREATE INDEX FK_nephthys_pageHierarchy_default       ON nephthys_pageHierarchy (pageHierarchyVersionId, region, parentPageid, sortOrder);


CREATE SEQUENCE seq_nephthys_pageHierarchyApproval_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE TABLE nephthys_pageHierarchyApproval
(
    pageHierarchyApprovalId integer NOT NULL DEFAULT nextval('seq_nephthys_pageHierarchyApproval_id'::regclass),
    pageHierarchyVersionId integer NOT NULL,
    oldPageStatusId integer, -- for the first the old is null
    newPageStatusId integer NOT NULL,
    userId integer NOT NULL,
    approvalDate timestamp with time zone NOT NULL DEFAULT now(),
    
    CONSTRAINT PK_nephthys_pageHierarchyApproval_Id     PRIMARY KEY (pageHierarchyApprovalId),
    CONSTRAINT FK_nephthys_pageHierarchyApproval_phvId  FOREIGN KEY (pageHierarchyVersionId) REFERENCES nephthys_pageHierarchyVersion (pageHierarchyVersionId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageHierarchyApproval_opsId  FOREIGN KEY (oldPageStatusId)        REFERENCES nephthys_pageStatus (pageStatusId)                     ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageHierarchyApproval_npsId  FOREIGN KEY (newPageStatusId)        REFERENCES nephthys_pageStatus (pageStatusId)                     ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_nephthys_pageHierarchyApproval_userId FOREIGN KEY (userId)                 REFERENCES nephthys_user (userId)                                 ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH
(
    OIDS = FALSE
);

CREATE INDEX FKI_nephthys_pageHierarchyApproval_oldPageStatusId ON nephthys_pageApproval(oldPageStatusId);
CREATE INDEX FKI_nephthys_pageHierarchyApproval_newPageStatusId ON nephthys_pageApproval(newPageStatusId);
CREATE INDEX FKI_nephthys_pageHierarchyApproval_userId          ON nephthys_pageApproval(userId);



GRANT SELECT ON TABLE nephthys_pageHierarchy TO nephthys_user;
GRANT SELECT ON TABLE nephthys_pageHierarchyVersion TO nephthys_user;
GRANT SELECT ON TABLE nephthys_pageVersion TO nephthys_user;

-- 6.6.16 - name refactorings
create table nephthys_page_region
(
    regionId serial primary key,
    name character varying(30) not null unique,
    description character varying(50) not null
);

create table nephthys_page_status
(
    statusId serial primary key,
    name character varying(100) not null unique,
    active boolean not null default true,
    online boolean not null default false,
    
    pagesAreEditable boolean not null default false,
    pagesAreDeleteable boolean not null default false,
    pagesRequireAction boolean not null default false,
    
    creationUserId integer not null references nephthys_user,
    creationDate timestamp with time zone not null default now(),
    
    lastEditUserId integer not null references nephthys_user,
    lastEditDate timestamp with time zone not null default now()
);

create table nephthys_page_statusFlow
(
    statusFlowId serial primary key,
    statusId integer not null references nephthys_page_status,
    nextStatusId integer not null references nephthys_page_status
);

create table nephthys_page_page
(
    pageId        serial primary key,
    pageVersionId integer,
    creationDate  timestamp with time zone not null default now()
);

create table nephthys_page_pageVersion
(
    pageVersionId serial primary key,
    pageId integer not null references nephthys_page_page on delete cascade,
    majorVersion integer not null default 1,
    minorVersion integer not null default 0,
    statusId integer references nephthys_page_status,
    useDynamicSuffixes boolean not null default false,
    
    linktext character varying(30) not null,
    link character varying(100) not null,
    title character varying(160) not null default '',
    description character varying(160) not null default '',
    content text,
    
    creationUserId integer not null references nephthys_user,
    creationDate timestamp with time zone not null default now(),
    
    lastEditUserId integer not null references nephthys_user,
    lastEditDate timestamp with time zone not null default now()
);


create table nephthys_page_hierarchy
(
    hierarchyId serial primary key,
    statusId integer not null references nephthys_page_status,
    version integer not null unique,
    
    creationUserId integer not null references nephthys_user,
    creationDate timestamp with time zone not null default now(),
    
    lastEditUserId integer not null references nephthys_user,
    lastEditDate timestamp with time zone not null default now()
);

create table nephthys_page_hierarchyPage
(
    hierarchyPageId serial primary key,
    hierarchyId integer not null references nephthys_page_hierarchy,
    regionId integer not null references nephthys_page_region,
    pageId integer not null references nephthys_page_page,
    parentPageId integer references nephthys_page_page,
    sortOrder integer not null,
    
    unique (hierarchyId, regionId, parentPageid, sortOrder)
);

create table nephthys_page_approval
(
    approvalId serial primary key,
    pageVersionId integer references nephthys_page_pageVersion,
    hierarchyId integer references nephthys_page_hierarchy,
    
    prevStatusId integer references nephthys_page_status,
    nextStatusId integer not null references nephthys_page_status,
    
    userId integer not null references nephthys_user,
    approvalDate timestamp with time zone not null default now(),
    
    check (pageVersionId IS NOT NULL or hierarchyId IS NOT NULL)
);



GRANT SELECT ON TABLE nephthys_page_region TO nephthys_user;
GRANT SELECT ON TABLE nephthys_page_status TO nephthys_user;
GRANT SELECT ON TABLE nephthys_page_statusFlow TO nephthys_user;
GRANT SELECT ON TABLE nephthys_page_page TO nephthys_user;
GRANT SELECT ON TABLE nephthys_page_pageVersion TO nephthys_user;
GRANT SELECT ON TABLE nephthys_page_hierarchy TO nephthys_user;
GRANT SELECT ON TABLE nephthys_page_hierarchyPage TO nephthys_user;
GRANT SELECT ON TABLE nephthys_page_approval TO nephthys_user;

alter table nephthys_page_status add column pagesRequireAction boolean not null default false;


-- 10.6.

alter table nephthys_page_hierarchyPage rename to nephthys_page_sitemapPage;
alter table nephthys_page_sitemapPage rename column hierarchyPageId to sitemapPageId;
alter table nephthys_page_hierarchy rename to nephthys_page_sitemap;
alter table nephthys_page_sitemap rename column hierarchyId to sitemapId;
alter table nephthys_page_sitemapPage rename column hierarchyId to sitemapId;

alter sequence nephthys_page_hierarchy_hierarchyid_seq rename to nephthys_page_sitemap_sitemapid_seq;
alter sequence nephthys_page_hierarchyPage_hierarchyPageid_seq rename to nephthys_page_sitemapPage_sitemapPageid_seq;


-- 14.6.

create table nephthys_page_statistics
(
    statisticsId serial primary key,
    pageId integer not null references nephthys_page_page on delete cascade,
    completeLink character varying(1024),
    visitDate  timestamp with time zone not null default now()
);


INSERT INTO nephthys_page_statistics (pageId, completeLink, visitDate) SELECT tmp.pageId, tmp.link, tmp.visitDate FROM (
SELECT page.pageId,
       statistics.link,
       regexp_matches(statistics.link, page.preparredLink || page.suffix || '$', 'i') parameter,
       statistics.visitDate
  FROM (
SELECT pv.pageId,
'^' || replace(pv.link, '/', '\/') preparredLink,
CASE 
WHEN pv.useDynamicSuffixes = true THEN 
'(?:\/(\w*|\-|\s|\.)*)*'
ELSE 
''
END suffix
FROM nephthys_page_pageVersion pv
) page,
(  SELECT s.link, s.visitDate
FROM nephthys_statistics s
) statistics
ORDER BY statistics.visitDate) tmp;


drop table nephthys_statistics;
drop sequence seq_nephthys_statistics_id;

GRANT SELECT, INSERT ON TABLE nephthys_page_statistics TO nephthys_user;
GRANT SELECT, UPDATE ON SEQUENCE nephthys_page_statistics_statisticsid_seq TO nephthys_user;

alter table nephthys_page_approval rename hierarchyId to sitemapId;

-- 21.6.2016

alter table nephthys_serversetting add column moduleId integer references nephthys_module on delete cascade;

alter table nephthys_serversetting add constraint UK_nephthys_serverSetting_sortOrder unique (sortOrder, moduleId);

alter table nephthys_serversetting alter column key TYPE character varying(80);

insert into nephthys_serversetting 
    (
        key,
        value,
        type,
        description,
        systemKey,
        readonly,
        hidden,
        creatorUserId,
        lastEditorUserId,
        alwaysRevalidate,
        sortOrder,
        moduleId
    )
SELECT * FROM (
SELECT 
        'com.IcedReaper.blog.' || bs.key as key,
        CASE WHEN bs.value = '1' THEN 'true' ELSE 'false' END as value,
        cast('boolean' as settingtype),
        description,
        false,
        false,
        false,
        1,
        1,
        false,
        settingId,
        19
FROM icedreaper_blog_settings bs) bs2;

drop table icedreaper_blog_settings;
drop sequence seq_icedreaper_blog_setting_id;

alter table nephthys_theme add column availableWww boolean default true NOT NULL;
alter table nephthys_theme add column availableAdmin boolean default true NOT NULL;

alter table nephthys_user rename column themeId to wwwThemeId;
alter table nephthys_user add column adminThemeId integer references nephthys_theme;

-- 22.6.16

GRANT SELECT, INSERT ON TABLE nephthys_user TO nephthys_user;
GRANT SELECT, UPDATE ON SEQUENCE seq_nephthys_user_id TO nephthys_user;

-- 23.6.16
alter table icedreaper_gallery_statistics rename column opendate to visitDate;

-- 24.6.2016
alter table icedreaper_blog_statistics rename column opendate to visitDate;


create table IcedReaper_gallery_status
(
    statusId serial primary key,
    name character varying(100) not null unique,
    active boolean not null default true,
    online boolean not null default false,
    
    galleriesAreEditable boolean not null default false,
    galleriesAreDeleteable boolean not null default false,
    galleriesRequireAction boolean not null default false,
    
    creationUserId integer not null references nephthys_user,
    creationDate timestamp with time zone not null default now(),
    
    lastEditUserId integer not null references nephthys_user,
    lastEditDate timestamp with time zone not null default now()
);

create table IcedReaper_gallery_statusFlow
(
    statusFlowId serial primary key,
    statusId integer not null references IcedReaper_gallery_status,
    nextStatusId integer not null references IcedReaper_gallery_status
);

create table IcedReaper_gallery_approval
(
    approvalId serial primary key,
    galleryId integer references IcedReaper_gallery_gallery,
    
    prevStatusId integer references IcedReaper_gallery_status,
    nextStatusId integer not null references IcedReaper_gallery_status,
    
    userId integer not null references nephthys_user,
    approvalDate timestamp with time zone not null default now(),
    
    check (galleryId IS NOT NULL)
);

alter table IcedReaper_gallery_gallery add column statusId integer references IcedReaper_gallery_status;

INSERT INTO IcedReaper_gallery_status VALUES
(
    1,
    'In Erstellung',
    true,
    true,
    
    true,
    true,
    true,
    
    1,
    now(),
    
    1,
    now()
);

update IcedReaper_gallery_gallery SET statusId = 1;

alter table IcedReaper_gallery_gallery alter column statusId SET NOT NULL;


GRANT SELECT ON TABLE IcedReaper_gallery_status TO nephthys_user;

alter table IcedReaper_gallery_gallery drop column activeStatus;

alter table IcedReaper_gallery_status rename column galleriesRequireAction to showInTasklist;
alter table IcedReaper_gallery_status rename column galleriesAreDeleteable to deleteable;
alter table IcedReaper_gallery_status rename column galleriesAreEditable   to editable;

alter table nephthys_module_option add column multiple boolean default false NOT NULL;

-- 25.06.2016
alter table nephthys_module ADD column useDynamicUrlSuffix boolean default false NOT NULL;
alter table nephthys_page_pageVersion rename column useDynamicSuffixes to useDynamicUrlSuffix;

alter table Nephthys_page_status rename column pagesRequireAction to showInTasklist;
alter table Nephthys_page_status rename column pagesAreDeleteable to deleteable;
alter table Nephthys_page_status rename column pagesAreEditable   to editable;


alter table nephthys_module add column integratedSearch boolean default false NOT NULL;
alter table Icedreaper_gallery_gallery add column title character varying(160);
update IcedReaper_gallery_gallery SET title = headline;
alter table IcedReaper_gallery_gallery alter column title set not null;


create table IcedReaper_blog_status
(
    statusId serial primary key,
    name character varying(100) not null unique,
    active boolean not null default true,
    online boolean not null default false,
    
    editable boolean not null default false,
    deleteable boolean not null default false,
    showInTasklist boolean not null default false,
    
    creationUserId integer not null references nephthys_user,
    creationDate timestamp with time zone not null default now(),
    
    lastEditUserId integer not null references nephthys_user,
    lastEditDate timestamp with time zone not null default now()
);

create table IcedReaper_blog_statusFlow
(
    statusFlowId serial primary key,
    statusId integer not null references IcedReaper_blog_status,
    nextStatusId integer not null references IcedReaper_blog_status
);

create table IcedReaper_blog_approval
(
    approvalId serial primary key,
    blogpostId integer references IcedReaper_blog_blogpost,
    
    prevStatusId integer references IcedReaper_blog_status,
    nextStatusId integer not null references IcedReaper_blog_status,
    
    userId integer not null references nephthys_user,
    approvalDate timestamp with time zone not null default now(),
    
    check (blogpostId IS NOT NULL)
);

alter table IcedReaper_blog_blogpost add column statusId integer references IcedReaper_blog_status;

INSERT INTO IcedReaper_blog_status VALUES
(
    1,
    'In Erstellung',
    true,
    true,
    
    true,
    true,
    true,
    
    1,
    now(),
    
    1,
    now()
);

update IcedReaper_blog_blogpost SET statusId = 1;

alter table IcedReaper_blog_blogpost alter column statusId SET NOT NULL;

GRANT SELECT ON TABLE IcedReaper_blog_status TO nephthys_user;

alter table IcedReaper_blog_blogpost drop column released;


alter table nephthys_serversetting add column application character varying (5) DEFAULT NULL;
alter table nephthys_serversetting add check (application IS NULL OR application = 'WWW' OR application = 'ADMIN');
alter table nephthys_serversetting add constraint UK_nephthys_serverSetting_keyName unique (key, application);


alter table IcedReaper_gallery_picture alter column title type character varying(250);
alter table IcedReaper_gallery_picture alter column alt type character varying(250);

alter table nephthys_page_pageVersion
DROP CONSTRAINT nephthys_page_pageversion_pageid_fkey,
ADD CONSTRAINT nephthys_page_pageversion_pageid_fkey
   FOREIGN KEY (pageId)
   REFERENCES nephthys_page_page(pageId)
   ON DELETE CASCADE;
   
alter table nephthys_user alter column avatarFilename type character varying(80);

GRANT SELECT, INSERT, UPDATE ON TABLE nephthys_user TO nephthys_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE nephthys_user_extProperty TO nephthys_user;
GRANT SELECT, UPDATE ON SEQUENCE seq_nephthys_user_extproperty_id TO nephthys_user;


alter table nephthys_statistics_login rename to nephthys_user_statistics;
alter table nephthys_user_statistics rename column loginId to statisticsId;


create table nephthys_search_statistics
(
    statisticsId serial primary key,
    searchString character varying(250) NOT NULL,
    searchDate timestamp with time zone not null default now(),
    referer character varying(1024) NOT NULL,
    userId integer references nephthys_user ON DELETE SET NULL,
    resultCount integer NOT NULL
);

create index IDX_nephthys_search_statistics_searchDate ON nephthys_search_statistics(searchDate);

GRANT SELECT, INSERT ON TABLE nephthys_search_statistics TO nephthys_user;
GRANT SELECT, UPDATE ON SEQUENCE nephthys_search_statistics_statisticsid_seq TO nephthys_user;

create table IcedReaper_permissionRequest_request
(
    requestId serial primary key,
    userId integer not null references nephthys_user on delete cascade,
    moduleId integer not null references nephthys_module on delete cascade,
    roleId integer not null references nephthys_role on delete cascade,
    
    status integer not null default 0,
    
    reason character varying(500),
    
    creationDate timestamp with time zone not null default now(),
    
    adminUserId integer references nephthys_user on delete set null,
    responseDate timestamp with time zone default null,
    comment character varying(500)
    
    check(status = -1 OR status = 0 OR status = 1)
);

create unique index UIDX_IcedReaper_permissionRequest_req_umrId ON IcedReaper_permissionRequest_request (userId, moduleId, roleId) WHERE (status = 0);
    
GRANT SELECT, INSERT ON TABLE IcedReaper_permissionRequest_request TO nephthys_user;
GRANT SELECT, UPDATE ON SEQUENCE icedreaper_permissionrequest_request_requestid_seq TO nephthys_user;

-- 20.7.2016
alter table nephthys_page_statistics add column regionId integer references nephthys_page_region on delete set null;

update nephthys_page_statistics stats
   set regionId = (    SELECT sp.regionId
                         FROM nephthys_page_sitemapPage sp
                   INNER JOIN nephthys_page_sitemap sm ON sp.sitemapId = sm.sitemapId
                   INNER JOIN nephthys_page_status s ON sm.statusId = s.statusId
                        WHERE stats.pageId = sp.pageId
                          AND s.online = true);
update nephthys_page_statistics stats
   set regionId = 1
 where regionId IS NULL
   and lower(completeLink) LIKE '/faq%'
    or lower(completeLink) LIKE '/reviews%';
update nephthys_page_statistics stats
   set regionId = 2
 where regionId IS NULL
   and lower(completeLink) LIKE '/kontakt%';

alter table nephthys_page_statistics alter column regionId SET NOT NULL;

alter table nephthys_page_region add column showInStatistics boolean default true NOT NULL;

create table IcedReaper_references_reference
(
    referenceId serial primary key,
    
    name character varying(250) unique,
    since date not null,
    quote text not null,
    homepage character varying (1024),
    imageName character varying(250),
    
    position integer not null unique,
    
    
    creatorUserId integer not null references nephthys_user,
    creationDate timestamp with time zone not null default now(),
    
    lastEditorUserId integer not null references nephthys_user,
    lastEditDate timestamp with time zone not null default now()
);

GRANT SELECT ON TABLE IcedReaper_references_reference TO nephthys_user;

create table nephthys_user_permissionRole
(
    permissionRoleId serial primary key,
    name character varying(50) not null unique,
    value integer unique not null,
    
    check(value >= 0)
);

insert into nephthys_user_permissionRole
(
    permissionRoleId,
    name,
    value
)
SELECT roleId, name, value FROM nephthys_role;

create table nephthys_user_permissionSubGroup
(
    permissionSubGroupId serial primary key,
    moduleId integer not null references nephthys_module on delete cascade,
    name character varying(50),
    
    unique (moduleId, name)
);

create table nephthys_user_permission
(
    permissionId serial primary key,
    userId integer not null references nephthys_user on delete cascade,
    permissionRoleId integer not null references nephthys_user_permissionRole on delete cascade,
    moduleId integer not null references nephthys_module on delete cascade,
    permissionSubGroupId integer default null references nephthys_user_permissionSubGroup on delete cascade,
    
    creatorUserId integer not null references nephthys_user on delete set null,
    creationDate timestamp with time zone not null default now(),
    lastEditorUserId integer not null references nephthys_user on delete set null,
    lastEditDate timestamp with time zone not null default now(),
    
    unique (userId, moduleId, permissionSubGroupId)
);

insert into nephthys_user_permission
(
    userId,
    permissionRoleId,
    moduleId,
    
    creatorUserId,
    creationDate,
    lastEditorUserId,
    lastEditDate
)
SELECT 
    userId,
    roleId,
    moduleId,
    
    creatorUserId,
    creationDate,
    lastEditorUserId,
    lastEditDate
FROM nephthys_permission;

alter table IcedReaper_permissionRequest_request drop constraint IcedReaper_permissionRequest_request_roleId_fkey;
alter table IcedReaper_permissionRequest_request add constraint IcedReaper_permissionRequest_request_roleId_fkey foreign key (roleId) references nephthys_user_permissionRole on delete cascade;

drop table nephthys_permission;
drop table nephthys_role;

GRANT SELECT ON TABLE nephthys_user_permission TO nephthys_user;
GRANT SELECT ON TABLE nephthys_user_permissionSubGroup TO nephthys_user;
GRANT SELECT ON TABLE nephthys_user_permissionRole TO nephthys_user;


alter table nephthys_user_extPropertyKey add column type character varying(125) default 'string' not null;
alter table nephthys_user_extPropertyKey add constraint nephthys_user_extPropertyKey_check check(type in ('string', 'date'));

alter table nephthys_user_extPropertyKey add column sortOrder numeric;
update nephthys_user_extPropertyKey SET sortOrder = extPropertyKeyId;
alter table nephthys_user_extPropertyKey alter column sortOrder drop not null;
alter table nephthys_user_extPropertyKey add unique (sortOrder);

alter table nephthys_user_extPropertyKey drop constraint nephthys_user_extPropertyKey_check;
alter table nephthys_user_extPropertyKey add constraint nephthys_user_extPropertyKey_check check(type in ('string', 'date', 'link', 'githubuser', 'facebookuser', 'twitteruser', 'facebookpage'));


CREATE TABLE IcedReaper_blog_picture
(
  pictureId SERIAL not null primary key,
  blogpostId integer NOT NULL references IcedReaper_blog_blogpost on delete cascade,
  pictureFilename character varying(150) NOT NULL unique,
  thumbnailFilename character varying(150) NOT NULL,
  title character varying(250),
  alt character varying(250),
  caption character varying(300),
  sortid integer NOT NULL,
  
  unique (blogpostId, sortId)
);
GRANT SELECT ON TABLE icedreaper_blog_picture TO nephthys_user;

--alter table IcedReaper_blog_blogpost add column pictureLayout;



create table nephthys_user_blacklist
(
    blacklistId serial not null primary key,
    namepart character varying(100) not null unique,
    
    creationUserId integer not null references nephthys_user on delete set null,
    creationDate timestamp with time zone not null default now()
);
GRANT SELECT ON TABLE nephthys_user_blacklist TO nephthys_user;

CREATE OR REPLACE FUNCTION nephthys_user_checkUsername(IN username character varying(255))
RETURNS BOOLEAN AS $$
DECLARE usernameNotBlocked BOOLEAN;
BEGIN
        SELECT COUNT(*) = 0 INTO usernameNotBlocked
          FROM nephthys_user_blacklist
         WHERE lower($1) like '%' || lower(namepart) || '%';

        RETURN usernameNotBlocked;
END;
$$ LANGUAGE plpgsql;
GRANT EXECUTE ON FUNCTION nephthys_user_checkUsername(IN username character varying(255)) TO nephthys_user;

alter table nephthys_user add constraint nephthys_user_username_check check(nephthys_user_checkUsername(username));

alter table nephthys_user_extPropertyKey rename column createdDate to creationDate;