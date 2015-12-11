/* ~~~~~~~~~~~~~~~~~~ T H E M E ~~~~~~~~~~~~~~~~~~ */

CREATE SEQUENCE seq_nephthys_theme_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_theme_id OWNER TO nephthys_admin;
  
CREATE TABLE public.nephthys_theme
(
  themeid numeric NOT NULL DEFAULT nextval('seq_nephthys_theme_id'::regclass), 
  name character varying NOT NULL, 
  foldername character varying,
  active boolean NOT NULL DEFAULT true, 
  
  CONSTRAINT PK_nephthys_theme_themeId PRIMARY KEY (themeId),
  CONSTRAINT UK_nephthys_theme_name UNIQUE (name),
  CONSTRAINT UK_nephthys_theme_path UNIQUE (foldername)
)
WITH (
  OIDS=FALSE
);

CREATE INDEX IDX_nephthys_theme_active ON nephthys_theme(active);

ALTER TABLE nephthys_theme OWNER TO nephthys_admin;

GRANT ALL    ON TABLE nephthys_theme TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_theme TO nephthys_user;

INSERT INTO nephthys_theme
            (
                themeId,
                name,
                folderName,
                active
            )
     VALUES (
                1,
                'default',
                'default',
                true
            );

/* ~~~~~~~~~~~~~~~~~~ U S E R ~~~~~~~~~~~~~~~~~~ */

CREATE SEQUENCE seq_nephthys_user_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_user_id OWNER TO nephthys_admin;

CREATE TABLE nephthys_user
(
  userid integer NOT NULL DEFAULT nextval('seq_nephthys_user_id'::regclass),
  username character varying(20) NOT NULL,
  email character varying(128) NOT NULL,
  password character varying(255),
  registrationDate timestamp with time zone NOT NULL DEFAULT now(),
  themeid integer NOT NULL,
  active boolean DEFAULT true,
  avatarFilename character varying(35) NOT NULL DEFAULT 'anonymous.png',
  
  CONSTRAINT PK_nephthys_user_userId PRIMARY KEY (userid),
  CONSTRAINT FK_nephthys_user_themeId FOREIGN KEY (themeid) REFERENCES nephthys_theme (themeid) ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);

CREATE        INDEX FKI_nephthys_user_themeId          ON nephthys_user(themeId);
CREATE        INDEX IDX_nephthys_user_active           ON nephthys_user(active);
CREATE        INDEX IDX_nephthys_user_username         ON nephthys_user(username);
CREATE        INDEX IDX_nephthys_user_usernamePassword ON nephthys_user(username, password);
CREATE UNIQUE INDEX UK_nephthys_user_email             ON nephthys_user(lower(email));
CREATE UNIQUE INDEX UK_nephthys_user_userName          ON nephthys_user(lower(username));
  
ALTER TABLE nephthys_user OWNER TO nephthys_admin;

GRANT ALL    ON TABLE nephthys_user TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_user TO nephthys_user;

INSERT INTO nephthys_user
            (
                userId,
                username,
                email,
                password,
                themeId
            )
            /* todo: dynamic */
     VALUES (
                1,
                'IcedReaper',
                'admin@nephthys.com',
                'Te5t123', /* encrypt */
                1
            );

/* ~~~~~~~~~~~~~~~~~~ E N C R Y P T M E T H O D ~~~~~~~~~~~~~~~~~~ */

CREATE SEQUENCE seq_nephthys_encryptionMethod_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_encryptionMethod_id
  OWNER TO nephthys_admin;

CREATE TABLE nephthys_encryptionMethod
(
  encryptionMethodId integer NOT NULL DEFAULT nextval('seq_nephthys_encryptionMethod_id'::regclass),
  algorithm character varying(20) NOT NULL,
  active boolean DEFAULT true,
  
  CONSTRAINT PK_nephthys_encryptionMethod_id PRIMARY KEY (encryptMethodId),
  CONSTRAINT UK_nephthys_encryptionMethod_algorithm UNIQUE (algorithm)
)
WITH (
  OIDS=FALSE
);

CREATE INDEX IDX_nephthys_encryptionMethod_active ON nephthys_encryptionMethod(active);
  
ALTER TABLE nephthys_encryptionMethod OWNER TO nephthys_admin;

GRANT ALL    ON TABLE nephthys_encryptionMethod TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_encryptionMethod TO nephthys_user;

INSERT INTO nephthys_encryptionMethod
            (
                encryptionMethodId,
                algorithm,
                active
            )
     VALUES (
                1,
                'AES',
                true
            );
INSERT INTO nephthys_encryptionMethod
            (
                encryptionMethodId,
                algorithm,
                active
            )
     VALUES (
                2,
                'BLOWFISH',
                true
            );
INSERT INTO nephthys_encryptionMethod
            (
                encryptionMethodId,
                algorithm,
                active
            )
     VALUES (
                3,
                'DES',
                true
            );
INSERT INTO nephthys_encryptionMethod
            (
                encryptionMethodId,
                algorithm,
                active
            )
     VALUES (
                4,
                'DESEDE',
                true
            );

/* ~~~~~~~~~~~~~~~~~~ S E R V E R   S E T T I N G S ~~~~~~~~~~~~~~~~~~ */
CREATE SEQUENCE seq_nephthys_serverSetting_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_serverSetting_id OWNER TO nephthys_admin;

CREATE TABLE nephthys_serverSetting
(
  serverSettingId integer NOT NULL DEFAULT nextval('seq_nephthys_serverSetting_id'::regclass),
  key character varying(40),
  value character varying(160),
  type character varying(15) NOT NULL,
  description character varying(75) NOT NULL,
  systemKey boolean NOT NULL DEFAULT FALSE,
  readonly boolean NOT NULL DEFAULT FALSE,
  createdUserId integer NOT NULL,
  createdDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate  timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_nephthys_serverSetting_id PRIMARY KEY (serverSettingId),
  CONSTRAINT FK_nephthys_serverSettings_setUserId        FOREIGN KEY (createdUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_nephthys_serverSettings_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE UNIQUE INDEX UK_nephthys_serverSetting_name    ON nephthys_serverSetting(lower(key));
  
ALTER TABLE nephthys_serverSetting OWNER TO nephthys_admin;

GRANT ALL    ON TABLE nephthys_serverSetting TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_serverSetting TO nephthys_user;


/* ~~~~~~~~~~~~~~~~~~ M O D U L E ~~~~~~~~~~~~~~~~~~ */

CREATE SEQUENCE seq_nephthys_module_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_module_id OWNER TO nephthys_admin;

CREATE TABLE public.nephthys_module
(
  moduleid integer NOT NULL DEFAULT nextval('seq_nephthys_module_id'::regclass),
  modulename character varying(100) NOT NULL,
  description character varying(100) NOT NULL,
  active boolean NOT NULL DEFAULT true,
  sortorder integer NOT NULL,
  
  CONSTRAINT PK_nephthys_module_id PRIMARY KEY (moduleid),
  CONSTRAINT UK_nephthys_module_sortOrder UNIQUE (sordorder)
) 
WITH (
  OIDS = FALSE
);

CREATE UNIQUE INDEX UK_nephthys_module_name    ON nephthys_module(lower(modulename));
CREATE        INDEX IDX_nephthys_module_active ON nephthys_module(active);
  
ALTER TABLE nephthys_module OWNER TO nephthys_admin;

GRANT ALL    ON TABLE nephthys_module TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_module TO nephthys_user;

/* ~~~~~~~~~~~~~~~~~~ P A G E S ~~~~~~~~~~~~~~~~~~ */

CREATE SEQUENCE seq_nephthys_page_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_page_id OWNER TO nephthys_admin;

CREATE TABLE public.nephthys_page
(
  pageid integer NOT NULL DEFAULT nextval('seq_nephthys_page_id'::regclass),
  parentid integer,
  linktext character varying(30) NOT NULL,
  link character varying(100) NOT NULL,
  title character varying(160),
  description character varying(160),
  content text,
  sortOrder integer,
  useDynamicSuffixes boolean NOT NULL DEFAULT true,
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  active boolean NOT NULL DEFAULT true,
  region character varying(20) NOT NULL DEFAULT 'header',
  
  CONSTRAINT PK_nephthys_page_id PRIMARY KEY (pageid),
  CONSTRAINT FK_nephthys_page_parentId         FOREIGN KEY (parentid)         REFERENCES nephthys_page (pageid) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_nephthys_page_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_nephthys_page_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
) 
WITH (
  OIDS = FALSE
);

CREATE        INDEX FKI_nephthys_page_parentid         ON nephthys_page(parentid);
CREATE UNIQUE INDEX UK_nephthys_page_link              ON nephthys_page(lower(link));
CREATE        INDEX FKI_nephthys_page_creatorUserId    ON nephthys_page(creatorUserId);
CREATE        INDEX FKI_nephthys_page_lastEditorUserId ON nephthys_page(lastEditorUserId);
CREATE        INDEX IDX_nephthys_page_active           ON nephthys_page(active);
CREATE        INDEX IDX_nephthys_page_sortOrder        ON nephthys_page(sortOrder);
CREATE        INDEX IDX_nephthys_page_defaultParam     ON nephthys_page(parentId, region, active, sortOrder);

ALTER TABLE nephthys_page OWNER TO nephthys_admin;

GRANT ALL    ON TABLE nephthys_page TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_page TO nephthys_user;


/* ~~~~~~~~~~~~~~~~~~ E R R O R L O G ~~~~~~~~~~~~~~~~~~ */

CREATE SEQUENCE seq_nephthys_errorSettings_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_errorSettings_id OWNER TO nephthys_admin;

CREATE TABLE public.nephthys_errorSettings
(
  errorSettingsId integer NULL NULL DEFAULT nextval('seq_nephthys_errorSettings_id'::regclass),
  errorCode character varying(75) NOT NULL,
  errorTemplate character varying(50) NOT NULL DEFAULT 'errorTemplate.cfm',
  errorType character varying(75) NOT NULL, /* type to the errorTemplate (e.g. 404 for all not found messages) */
  log boolean NOT NULL DEFAULT TRUE,
  
  CONSTRAINT PK_nephthys_errorSettings_id PRIMARY KEY (errorSettingsId)
)
WITH (
  OIDS = FALSE
);

CREATE        INDEX IDX_nephthys_errorSettings_errorCode ON nephthys_errorSettings(errorCode);
CREATE UNIQUE INDEX UK_nephthys_errorSettings_errorCode  ON nephthys_errorSettings(lower(errorCode));

ALTER TABLE nephthys_errorSettings OWNER TO nephthys_admin;

GRANT ALL            ON TABLE nephthys_errorSettings TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE nephthys_errorSettings TO nephthys_user;


CREATE SEQUENCE seq_nephthys_error_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_error_id OWNER TO nephthys_admin;

CREATE TABLE public.nephthys_error
(
  errorId integer NOT NULL DEFAULT nextval('seq_nephthys_error_id'::regclass),
  errorCode character varying(75) NOT NULL,
  link character varying(255),
  message character varying(300) NOT NULL,
  details character varying(200),
  stacktrace text NOT NULL,
  userId integer,
  /*template character varying(255) NOT NULL,
  line integer NOT NULL,*/
  errorDate timestamp with time zone NOT NULL DEFAULT now(),
  referrer character varying(255),
  userAgent character varying(75),
  
  CONSTRAINT PK_nephthys_error_id PRIMARY KEY (errorId),
  CONSTRAINT FK_nephthys_error_userId FOREIGN KEY (userId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE INDEX IDX_nephthys_error_errorCode ON nephthys_error(errorCode);
CREATE INDEX IDX_nephthys_error_errorDate ON nephthys_error(errorDate);
CREATE INDEX IDX_nephthys_error_link      ON nephthys_error(link);

ALTER TABLE nephthys_error OWNER TO nephthys_admin;

GRANT ALL            ON TABLE nephthys_error TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE nephthys_error TO nephthys_user;


/* ~~~~~~~~~~~~~~~~~~ P E R M I S S I O N S ~~~~~~~~~~~~~~~~~~ */

CREATE SEQUENCE seq_nephthys_role_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_role_id OWNER TO nephthys_admin;

CREATE TABLE public.nephthys_role
(
  roleId integer NOT NULL DEFAULT nextval('seq_nephthys_role_id'::regclass),
  name character varying(50) NOT NULL,
  value integer NOT NULL,
  
  CONSTRAINT PK_nephthys_role_id PRIMARY KEY (roleId),
  CONSTRAINT UK_nephthys_role_name UNIQUE (name),
  CONSTRAINT UK_nephthys_role_value UNIQUE (value)
)
WITH (
  OIDS = FALSE
);

CREATE INDEX IDX_nephthys_role_nameValue ON nephthys_role(name, value);

ALTER TABLE nephthys_role OWNER TO nephthys_admin;

GRANT ALL    ON TABLE nephthys_role TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_role TO nephthys_user;

CREATE SEQUENCE seq_nephthys_permission_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_permission_id OWNER TO nephthys_admin;

CREATE TABLE public.nephthys_permission
(
  permissionId integer NOT NULL DEFAULT nextval('seq_nephthys_permission_id'::regclass),
  userId integer NOT NULL,
  roleId integer NOT NULL,
  moduleId integer NOT NULL,
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_nephthys_permission_id PRIMARY KEY (permissionId),
  CONSTRAINT FK_nephthys_permission_roleId           FOREIGN KEY (roleId)           REFERENCES nephthys_role   (roleId)   ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_nephthys_permission_moduleId         FOREIGN KEY (moduleId)         REFERENCES nephthys_module (moduleId) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_nephthys_permission_userId           FOREIGN KEY (userId)           REFERENCES nephthys_user   (userId)   ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_nephthys_permission_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user   (userId)   ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_nephthys_permission_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user   (userId)   ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE        INDEX IDX_nephthys_permission_roleUserModule ON nephthys_permission(roleId, userId, moduleId);
CREATE UNIQUE INDEX UK_nephthys_permission_userIdModuleId  ON nephthys_permission(userId, moduleId);

ALTER TABLE nephthys_permission OWNER TO nephthys_admin;

GRANT ALL    ON TABLE nephthys_permission TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_permission TO nephthys_user;

INSERT INTO nephthys_role
            (
                name,
                value
            )
     VALUES (
                'user',
                10
            );
INSERT INTO nephthys_role
            (
                name,
                value
            )
     VALUES (
                'editor',
                30
            );
INSERT INTO nephthys_role
            (
                name,
                value
            )
     VALUES (
                'admin',
                100
            );