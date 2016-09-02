CREATE TABLE nephthys_error
(
  errorId serial NOT NULL PRIMARY KEY,
  errorcode character varying(75) NOT NULL,
  link character varying(255),
  message character varying(300) NOT NULL,
  details character varying(200),
  stacktrace text NOT NULL,
  userId integer REFERENCES nephthys_user ON DELETE SET NULL,
  errorDate timestamp with time zone NOT NULL DEFAULT now(),
  referrer character varying(255),
  userAgent character varying(255)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_error OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_error TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE nephthys_error TO nephthys_user;

CREATE INDEX idx_errorcode ON nephthys_error (errorcode);
CREATE INDEX idx_errorDate ON nephthys_error (errorDate);
CREATE INDEX idx_link      ON nephthys_error (link);
CREATE INDEX fi_userId     ON nephthys_error (userId);



CREATE TABLE nephthys_errorsettings
(
  errorSettingsId serial NOT NULL PRIMARY KEY,
  errorcode character varying(75) NOT NULL,
  errorTemplate character varying(50) NOT NULL DEFAULT 'errorTemplate.cfm',
  errorType character varying(75) NOT NULL,
  log boolean NOT NULL DEFAULT true
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_errorsettings
  OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_errorsettings TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE nephthys_errorsettings TO nephthys_user;

CREATE INDEX idx_errorcode ON nephthys_errorsettings (errorcode);
CREATE UNIQUE INDEX ui_errorcode ON nephthys_errorsettings (lower(errorcode));