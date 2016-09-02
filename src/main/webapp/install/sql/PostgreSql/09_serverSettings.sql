CREATE TYPE settingtype AS ENUM
   ('bit',
    'number',
    'string',
    'boolean',
    'date',
    'datetime',
    'foreignKey',
    'enum',
    'component');
ALTER TYPE settingtype OWNER TO nephthys_admin;

CREATE TABLE nephthys_serversetting
(
  serverSettingId serial NOT NULL PRIMARY KEY,
  key character varying(80),
  value character varying(160) NOT NULL,
  type settingtype NOT NULL,
  description character varying(150) NOT NULL,
  systemKey boolean NOT NULL DEFAULT false,
  readonly boolean NOT NULL DEFAULT false,
  enumOptions character varying(500),
  foreignTableOptions character varying(500),
  hidden boolean NOT NULL DEFAULT false,
  lastEditorUserId integer REFERENCES nephthys_user ON DELETE SET NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  alwaysRevalidate boolean NOT NULL DEFAULT false,
  sortOrder integer NOT NULL,
  moduleId integer REFERENCES nephthys_module ON DELETE CASCADE,
  application character varying(5) DEFAULT NULL,
  
  UNIQUE (key, application),
  UNIQUE (sortorder, moduleid),
  
  CHECK (application IS NULL OR application = 'WWW' OR application = 'ADMIN')
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_serversetting OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_serversetting TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_serversetting TO nephthys_user;

CREATE TRIGGER trg_updatelasteditdate BEFORE UPDATE ON nephthys_serversetting
  FOR EACH ROW
  WHEN ((old.* IS DISTINCT FROM new.*))
  EXECUTE PROCEDURE updatelasteditdate();