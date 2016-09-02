CREATE TABLE nephthys_search_statistics
(
  statisticsId serial NOT NULL PRIMARY KEY,
  searchString character varying(250) NOT NULL,
  searchDate timestamp with time zone NOT NULL DEFAULT now(),
  referer character varying(1024) NOT NULL,
  userid integer REFERENCES nephthys_user ON DELETE SET NULL,
  resultcount integer NOT NULL
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_search_statistics OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_search_statistics TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE nephthys_search_statistics TO nephthys_user;

CREATE INDEX idx_searchdate ON nephthys_search_statistics (searchdate);