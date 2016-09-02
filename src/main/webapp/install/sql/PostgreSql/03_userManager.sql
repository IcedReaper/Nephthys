CREATE OR REPLACE FUNCTION nephthys_user_checkusername(username character varying)
  RETURNS boolean AS
$BODY$
DECLARE usernameNotBlocked boolean;
BEGIN
    SELECT COUNT(*) = 0 INTO usernameNotBlocked
      FROM nephthys_user_blacklist
     WHERE lower($1) like '%' || lower(namepart) || '%';

    RETURN usernameNotBlocked;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION nephthys_user_checkusername(character varying) OWNER TO nephthys_admin;
GRANT EXECUTE ON FUNCTION nephthys_user_checkusername(character varying) TO public;
GRANT EXECUTE ON FUNCTION nephthys_user_checkusername(character varying) TO nephthys_admin;
GRANT EXECUTE ON FUNCTION nephthys_user_checkusername(character varying) TO nephthys_user;

CREATE TABLE nephthys_user
(
  userId serial NOT NULL PRIMARY KEY,
  username character varying(20) NOT NULL unique,
  email character varying(128) NOT NULL unique,
  password character varying(255),
  registrationDate timestamp with time zone NOT NULL DEFAULT now(),
  avatarFilename character varying(80),
  wwwThemeId integer NOT NULL REFERENCES nephthys_theme,
  adminThemeId integer NOT NULL REFERENCES nephthys_theme,
  
  CHECK (nephthys_user_checkusername(username))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_user TO nephthys_admin;
GRANT SELECT, UPDATE, INSERT ON TABLE nephthys_user TO nephthys_user;

CREATE UNIQUE INDEX ui_username ON nephthys_user (LOWER(username));
CREATE UNIQUE INDEX ui_email ON nephthys_user (LOWER(email));

CREATE INDEX fi_theme_wwwThemeId ON nephthys_user (wwwThemeId);
CREATE INDEX fi_theme_adminThemeId ON nephthys_user (adminThemeId);



CREATE TABLE nephthys_user_blacklist
(
  blacklistId serial NOT NULL PRIMARY KEY,
  namepart character varying(100) NOT NULL unique,
  creatorUserid integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now()
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_blacklist
  OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_user_blacklist TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_user_blacklist TO nephthys_user;

CREATE INDEX fi_creatorUserId ON nephthys_user_blacklist (creatorUserId);



CREATE TABLE nephthys_user_extPropertyKey
(
  extPropertyKeyId serial NOT NULL PRIMARY KEY,
  keyname character varying(50) NOT NULL,
  description character varying(200) NOT NULL,
  creatorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  lastEditdate timestamp with time zone NOT NULL DEFAULT now(),
  type character varying(125) NOT NULL DEFAULT 'string'::character varying,
  sortorder numeric NOT NULL UNIQUE,
  
  CHECK (type::text = ANY (ARRAY['string'::character varying, 'date'::character varying]::text[]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_extpropertykey OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_user_extpropertykey TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_user_extpropertykey TO nephthys_user;

CREATE UNIQUE INDEX ui_keyname ON nephthys_user_extPropertyKey (lower(keyname));

CREATE INDEX fi_creatorUserId ON nephthys_user_extPropertyKey (creatorUserId);
CREATE INDEX fi_lastEditorUserId ON nephthys_user_extPropertyKey (lastEditorUserId);

CREATE TRIGGER trg_updatelasteditdate
  BEFORE UPDATE
  ON nephthys_user_extpropertykey
  FOR EACH ROW
  WHEN ((old.* IS DISTINCT FROM new.*))
  EXECUTE PROCEDURE updatelasteditdate();



CREATE TABLE nephthys_user_extProperty
(
  extPropertyId serial NOT NULL PRIMARY KEY,
  userId integer NOT NULL references nephthys_user ON DELETE CASCADE,
  extPropertyKeyId integer NOT NULL references nephthys_extPropertyKey on DELETE CASCADE,
  value character varying(255) NOT NULL,
  public boolean NOT NULL DEFAULT false,
  
  UNIQUE (userId, extPropertyKeyId)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_extProperty
  OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_user_extProperty TO nephthys_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE nephthys_user_extProperty TO nephthys_user;


CREATE INDEX fi_userId ON nephthys_user_extProperty (userid);
CREATE INDEX fi_extPropertyKeyId ON nephthys_user_extProperty (extPropertyKeyId);



CREATE TABLE nephthys_user_permissionRole
(
  permissionRoleId serial NOT NULL PRIMARY KEY,
  name character varying(50) NOT NULL,
  value integer NOT NULL unique,
  
  CHECK (value >= 0)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_permissionRole OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_user_permissionRole TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_user_permissionRole TO nephthys_user;

CREATE UNIQUE INDEX ui_name ON nephthys_user_permissionRole (lower(name));



CREATE TABLE nephthys_user_permissionSubGroup
(
  permissionSubGroupId serial NOT NULL PRIMARY KEY,
  moduleId integer NOT NULL REFERENCES nephthys_module ON DELETE CASCADE,
  name character varying(50)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_permissionsubgroup OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_user_permissionsubgroup TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_user_permissionsubgroup TO nephthys_user;

CREATE UNIQUE INDEX ui_moduleName ON nephthys_user_permissionSubGroup (moduleId, lower(name));
CREATE INDEX fi_moduleId ON nephthys_user_permissionSubGroup (moduleId);



CREATE TABLE nephthys_user_permission
(
  permissionId serial NOT NULL PRIMARY KEY,
  userId integer NOT NULL REFERENCES nephthys_user ON DELETE CASCADE,
  permissionRoleId integer NOT NULL REFERENCES nephthys_user_permissionRole,
  moduleId integer NOT NULL REFERENCES nephthys_module ON DELETE CASCADE,
  permissionSubGroupId integer REFERENCES nephthys_user_permissionSubGroup ON DELETE CASCADE,
  creatorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  
  UNIQUE (userId, moduleId, permissionSubGroupId)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_permission OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_user_permission TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_user_permission TO nephthys_user;

CREATE TRIGGER trg_updatelasteditdate
  BEFORE UPDATE
  ON nephthys_user_permission
  FOR EACH ROW
  WHEN ((old.* IS DISTINCT FROM new.*))
  EXECUTE PROCEDURE updatelasteditdate();

CREATE INDEX fi_userId ON nephthys_user_permission (userid);
CREATE INDEX fi_creatorUserId ON nephthys_user_permission (creatorUserId);
CREATE INDEX fi_lastEditorUserId ON nephthys_user_permission (lastEditorUserId);
CREATE INDEX fi_moduleId ON nephthys_user_permission (moduleId);
CREATE INDEX fi_permSubGroupId ON nephthys_user_permission (permissionSubGroupId);



CREATE TABLE nephthys_user_statistics
(
  statisticsId serial NOT NULL PRIMARY KEY,
  username character varying(200) NOT NULL,
  loginDate timestamp with time zone NOT NULL DEFAULT now(),
  successful boolean NOT NULL
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_statistics OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_user_statistics TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE nephthys_user_statistics TO nephthys_user;

CREATE INDEX idx_loginDate ON nephthys_user_statistics (loginDate);
CREATE INDEX idx_select ON nephthys_user_statistics (logindate, successful);
CREATE INDEX idx_successful ON nephthys_user_statistics (successful);
CREATE INDEX idx_username ON nephthys_user_statistics (username);

CREATE TRIGGER trg_updatelasteditdate
  BEFORE UPDATE
  ON nephthys_user_status
  FOR EACH ROW
  WHEN ((old.* IS DISTINCT FROM new.*))
  EXECUTE PROCEDURE updatelasteditdate();



CREATE TABLE nephthys_user_status
(
  statusId serial NOT NULL PRIMARY KEY,
  name character varying(100) NOT NULL,
  active boolean NOT NULL DEFAULT true,
  canLogin boolean NOT NULL DEFAULT false,
  showInTasklist boolean NOT NULL DEFAULT false,
  creatorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now()
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_status OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_user_status TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_user_status TO nephthys_user;

CREATE UNIQUE INDEX ui_name ON nephthys_user_status (lower(name));
CREATE INDEX fi_creatorUserId ON nephthys_user_status (creatorUserId);
CREATE INDEX fi_lastEditorUserId ON nephthys_user_status (lastEditorUserId);



CREATE TABLE nephthys_user_statusFlow
(
  statusFlowId serial NOT NULL PRIMARY KEY,
  statusId integer NOT NULL REFERENCES nephthys_user_status ON DELETE CASCADE,
  nextStatusId integer NOT NULL REFERENCES nephthys_user_status ON DELETE CASCADE,
  
  UNIQUE (statusId, nextStatusId)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_statusflow OWNER TO nephthys_admin;

CREATE INDEX fi_statusId ON nephthys_user_statusFlow (statusId);
CREATE INDEX fi_nextStatusId ON nephthys_user_statusFlow (nextStatusId);
  
  
CREATE TABLE nephthys_user_approval
(
  approvalId serial NOT NULL PRIMARY KEY,
  userId integer NOT NULL REFERENCES nephthys_user ON DELETE CASCADE,
  prevStatusId integer REFERENCES nephthys_user_status,
  newStatusId integer NOT NULL REFERENCES nephthys_user_status,
  approvalUserId integer NOT NULL REFERENCES nephthys_user ON DELETE SET NULL,
  approvalDate timestamp with time zone NOT NULL DEFAULT now()
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_user_approval OWNER TO nephthys_admin;

CREATE INDEX fi_userId ON nephthys_user_approval (userId);
CREATE INDEX fi_prevStatusId ON nephthys_user_approval (prevStatusId);
CREATE INDEX fi_newStatusId ON nephthys_user_approval (newStatusId);
CREATE INDEX fi_approvalUserId ON nephthys_user_approval (approvalUserId);

ALTER TABLE nephthys_user ADD COLUMN statusId integer NOT NULL REFERENCES nephthys_user_status;