CREATE TABLE nephthys_theme
(
  themeId serial NOT NULL PRIMARY KEY,
  name character varying(25) NOT NULL,
  active boolean NOT NULL DEFAULT true,
  folderName character varying(50),
  anonymousAvatarFilename character varying(50) NOT NULL DEFAULT 'anonymous.png',
  availableWww boolean NOT NULL DEFAULT true,
  availableAdmin boolean NOT NULL DEFAULT true
)
WITH (
  OIDS=FALSE
);
ALTER TABLE nephthys_theme OWNER TO nephthys_admin;
GRANT ALL ON TABLE nephthys_theme TO nephthys_admin;
GRANT SELECT ON TABLE nephthys_theme TO nephthys_user;

CREATE UNIQUE INDEX ui_name ON nephthys_theme (LOWER(name));
CREATE UNIQUE INDEX ui_folderName ON nephthys_theme (LOWER(folderName));