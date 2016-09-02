
CREATE TABLE nephthys_page_status
(
  statusId serial NOT NULL PRIMARY KEY,
  name character varying(100) NOT NULL,
  active boolean NOT NULL DEFAULT true,
  online boolean NOT NULL DEFAULT false,
  editable boolean NOT NULL DEFAULT false,
  deleteable boolean NOT NULL DEFAULT false,
  creatorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  showInTasklist boolean NOT NULL DEFAULT false
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_page_status OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_page_status TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_page_status TO nephthys_user;

CREATE UNIQUE INDEX ui_name ON nephthys_page_status (lower(name));
CREATE INDEX idx_online ON nephthys_page_status (active, online);

CREATE TRIGGER trg_updatelasteditdate
  BEFORE UPDATE
  ON nephthys_page_status
  FOR EACH ROW
  WHEN ((old.* IS DISTINCT FROM new.*))
  EXECUTE PROCEDURE updatelasteditdate();



CREATE TABLE nephthys_page_statusFlow
(
  statusFlowId serial NOT NULL PRIMARY KEY,
  statusId integer NOT NULL REFERENCES nephthys_page_status,
  nextStatusId integer NOT NULL REFERENCES nephthys_page_status,
  
  UNIQUE (statusId, nextStatusId)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_page_statusflow OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_page_statusflow TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_page_statusflow TO nephthys_user;

CREATE INDEX fi_statusId ON nephthys_page_statusFlow (statusId);
CREATE INDEX fi_nextStatusId ON nephthys_page_statusFlow (nextStatusId);



CREATE TABLE nephthys_page_page
(
  pageId serial NOT NULL PRIMARY KEY
  creationDate timestamp with time zone NOT NULL DEFAULT now()
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_page_page
  OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_page_page TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_page_page TO nephthys_user;

CREATE INDEX fi_pageVersionId ON nephthys_page_page (pageVersionId);



CREATE TABLE nephthys_page_pageVersion
(
  pageVersionId serial NOT NULL PRIMARY KEY,
  pageId integer NOT NULL REFERENCES nephthys_page_page ON DELETE CASCADE,
  majorVersion integer NOT NULL DEFAULT 1,
  minorVersion integer NOT NULL DEFAULT 0,
  statusId integer NOT NULL REFERENCES nephthys_page_status,
  useDynamicUrlSuffix boolean NOT NULL DEFAULT false,
  linktext character varying(30) NOT NULL,
  link character varying(100) NOT NULL,
  title character varying(160) NOT NULL DEFAULT ''::character varying,
  description character varying(160) NOT NULL DEFAULT ''::character varying,
  content text,
  creatorUserId integer NOT NULL REFERENCES nephthys_user,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL REFERENCES nephthys_user,
  lastEditdate timestamp with time zone NOT NULL DEFAULT now()
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_page_pageversion
  OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_page_pageversion TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_page_pageversion TO nephthys_user;

CREATE INDEX fi_pageId ON nephthys_page_pageVersion (pageId);
CREATE INDEX fi_statusId ON nephthys_page_pageVersion (statusId);
CREATE INDEX fi_creatorUserId ON nephthys_page_pageVersion (creatorUserId);
CREATE INDEX fi_lastEditorUserId ON nephthys_page_pageVersion (lastEditorUserId);
CREATE INDEX idx_link ON nephthys_page_pageVersion (statusId, link, statusId);

CREATE TRIGGER trg_updatelasteditdate
  BEFORE UPDATE
  ON nephthys_page_pageversion
  FOR EACH ROW
  WHEN ((old.* IS DISTINCT FROM new.*))
  EXECUTE PROCEDURE updatelasteditdate();



ALTER TABLE nephthys_page_page ADD COLUMN pageVersionId REFERENCES nephthys_page_pageVersion;



CREATE TABLE nephthys_page_region
(
  regionId serial NOT NULL PRIMARY KEy,
  name character varying(30) NOT NULL,
  description character varying(50),
  showInStatistics boolean NOT NULL DEFAULT true
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_page_region OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_page_region TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_page_region TO nephthys_user;

CREATE UNIQUE INDEX ui_name ON nephthys_page_region (lower(name));


CREATE TABLE nephthys_page_sitemap
(
  sitemapId serial NOT NULL PRIMARY KEY,
  statusId integer NOT NULL REFERENCES nephthys_page_status,
  version integer NOT NULL UNIQUE,
  creatorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now()
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_page_sitemap OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_page_sitemap TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_page_sitemap TO nephthys_user;

CREATE INDEX fi_statusId ON nephthys_page_sitemap (statusId);
CREATE INDEX fi_creatorUserId ON nephthys_page_sitemap (creatorUserId);
CREATE INDEX fi_lastEditorUserId ON nephthys_page_sitemap (lastEditorUserId);

CREATE INDEX idx_active ON nephthys_page_sitemap (statusId, version);

CREATE TRIGGER trg_updatelasteditdate
  BEFORE UPDATE
  ON nephthys_page_sitemap
  FOR EACH ROW
  WHEN ((old.* IS DISTINCT FROM new.*))
  EXECUTE PROCEDURE updatelasteditdate();


CREATE TABLE nephthys_page_sitemapPage
(
  sitemapPageId serial NOT NULL PRIMARY KEY,
  sitemapId integer NOT NULL REFERENCES nephthys_page_sitemap ON DELETE CASCADE,
  regionId integer NOT NULL REFERENCES nephthys_page_region,
  pageId integer NOT NULL REFERENCES nephthys_page_page,
  parentPageId integer REFERENCES nephthys_page_page,
  sortOrder integer NOT NULL,
  
  UNIQUE (sitemapId, regionId, parentPageId, sortOrder)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_page_sitemappage OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_page_sitemappage TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_page_sitemappage TO nephthys_user;

CREATE INDEX fi_sitemapId ON nephthys_page_sitemapPage (sitemapId);
CREATE INDEX fi_regionId ON nephthys_page_sitemapPage (regionId);
CREATE INDEX fi_pageId ON nephthys_page_sitemapPage (pageId);
CREATE INDEX fi_parentPageId ON nephthys_page_sitemapPage (parentPageId);

CREATE INDEX idx_active ON nephthys_page_sitemapPage (pageId, sitemapId);


CREATE TABLE nephthys_page_statistics
(
  statisticsId serial NOT NULL PRIMARY KEY,
  pageId integer NOT NULL REFERENCES nephthys_page_page ON DELETE CASCADE,
  completeLink character varying(1024),
  visitDate timestamp with time zone NOT NULL DEFAULT now(),
  regionId integer NOT NULL REFERENCES nephthys_page_region ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_page_statistics
  OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_page_statistics TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE nephthys_page_statistics TO nephthys_user;

CREATE INDEX fi_pageId ON nephthys_page_statistics (pageId);
CREATE INDEX fi_regionId ON nephthys_page_statistics (regionId);

CREATE INDEX idx_visitDate ON nephthys_page_statistics (visitDate);



CREATE TABLE nephthys_page_approval
(
  approvalId serial NOT NULL PRIMARY KEY,
  pageVersionId integer REFERENCES nephthys_page_pageVersion,
  sitemapid integer REFERENCES nephthys_page_sitemap,
  prevStatusId integer REFERENCES nephthys_page_status,
  newStatusId integer NOT NULL REFERENCES nephthys_page_status,
  approvalUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  approvalDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CHECK (pageversionid IS NOT NULL OR sitemapid IS NOT NULL)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_page_approval OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_page_approval TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_page_approval TO nephthys_user;

CREATE INDEX fi_pageVersionId ON nephthys_page_approval (pageVersionId);
CREATE INDEX fi_sitemapid ON nephthys_page_approval (sitemapid);
CREATE INDEX fi_prevStatusId ON nephthys_page_approval (prevStatusId);
CREATE INDEX fi_newStatusId ON nephthys_page_approval (newStatusId);
CREATE INDEX fi_approvalDate ON nephthys_page_approval (approvalDate);