CREATE TYPE optiontype AS ENUM
   ('boolean',
    'text',
    'select',
    'wysiwyg',
    'query');
ALTER TYPE optiontype OWNER TO nephthys_admin;

CREATE TABLE nephthys_module
(
  moduleId serial NOT NULL PRIMARY KEY,
  modulename character varying(100) NOT NULL,
  description character varying(100) NOT NULL,
  active boolean NOT NULL DEFAULT true,
  systemModule boolean NOT NULL DEFAULT true,
  sortOrder integer NOT NULL,
  availableWww boolean NOT NULL DEFAULT true,
  availableAdmin boolean NOT NULL DEFAULT true,
  useDynamicUrlSuffix boolean NOT NULL DEFAULT false,
  integratedSearch boolean NOT NULL DEFAULT false,
  canBeRootElement boolean NOT NULL DEFAULT false,
  canBeRootElementMultipleTimes boolean NOT NULL DEFAULT false,
  actualVersion character varying(25) NOT NULL DEFAULT '1.0',
  actualVersionNumber integer NOT NULL DEFAULT 1
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_module
  OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_module TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_module TO nephthys_user;

CREATE INDEX idx_availableAdmin ON nephthys_module (availableAdmin);
CREATE INDEX idx_availableWww   ON nephthys_module (availableWww);



CREATE TABLE nephthys_module_option
(
  optionId serial NOT NULL PRIMARY KEY,
  moduleId integer NOT NULL REFERENCES nephthys_module ON DELETE CASCADE,
  optionname character varying(100) NOT NULL,
  description character varying(100) NOT NULL,
  type optiontype NOT NULL,
  selectOptions text,
  sortOrder integer NOT NULL,
  multiple boolean NOT NULL DEFAULT false,
  UNIQUE (moduleid, sortorder)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_module_option
  OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_module_option TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_module_option TO nephthys_user;

CREATE UNIQUE INDEX ui_moduleOptionname on nephthys_module_option (moduleId, lower(optionName));
CREATE INDEX idx_optionname ON nephthys_module_option (optionname);
CREATE INDEX fi_moduleId ON nephthys_module_option (moduleId)


CREATE TABLE nephthys_module_subModule
(
  module_subId serial NOT NULL PRIMARY KEY,
  moduleId integer NOT NULL REFERENCES nephthys_module ON DELETE CASCADE,
  subModuleId integer NOT NULL REFERENCES nephthys_module ON DELETE CASCADE
  
  UNIQUE (moduleid, submoduleid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_module_submodule OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_module_submodule TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_module_submodule TO nephthys_user;

CREATE INDEX fi_moduleid ON nephthys_module_submodule (moduleid);
CREATE INDEX fi_subModuleid ON nephthys_module_submodule (subModuleid);