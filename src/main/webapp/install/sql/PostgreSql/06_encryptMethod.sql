CREATE TABLE nephthys_encryptionMethod
(
  encryptionMethodId serial NOT NULL PRIMARY KEY,
  algorithm character varying(20) NOT NULL,
  active boolean DEFAULT true
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_encryptionmethod OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_encryptionmethod TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_encryptionmethod TO nephthys_user;

CREATE INDEX idx_active ON nephthys_encryptionMethod (active);
CREATE UNIQUE INDEX ui_algorythm ON nephthys_encryptionMethod (lower(algorithm));