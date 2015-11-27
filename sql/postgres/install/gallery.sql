CREATE SEQUENCE seq_icedreaper_gallery_gallery_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_gallery_gallery_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_gallery_gallery
(
  galleryId integer NOT NULL DEFAULT nextval('seq_icedreaper_gallery_gallery_id'::regclass),
  headline character varying(100),
  description character varying(500),
  link character varying(150),
  folderName character varying(150),
  introduction character varying(400),
  story text,
  activeStatus boolean NOT NULL DEFAULT TRUE,
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_gallery_gallery_id PRIMARY KEY (galleryId),
  CONSTRAINT UK_icedreaper_gallery_gallery_headline   UNIQUE (lower(headline)),
  CONSTRAINT UK_icedreaper_gallery_gallery_folderName UNIQUE (lower(folderName)),
  CONSTRAINT FK_icedreaper_gallery_gallery_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_gallery_gallery_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
) 
WITH (
  OIDS = FALSE
);

CREATE        INDEX FKI_icedreaper_gallery_gallery_creatorUserId    ON icedreaper_gallery_gallery(creatorUserId);
CREATE        INDEX FKI_icedreaper_gallery_gallery_lastEditorUserId ON icedreaper_gallery_gallery(lastEditorUserId);
CREATE        INDEX IDX_icedreaper_gallery_gallery_activeStatus     ON icedreaper_gallery_gallery(activeStatus);
CREATE        INDEX IDX_icedreaper_gallery_gallery_link             ON icedreaper_gallery_gallery(link);
CREATE UNIQUE INDEX UK_icedreaper_gallery_gallery_headline          ON icedreaper_gallery_gallery(lower(headline));
CREATE UNIQUE INDEX UK_icedreaper_gallery_gallery_folderName        ON icedreaper_gallery_gallery(lower(folderName));

ALTER TABLE icedreaper_gallery_gallery OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_gallery_gallery TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_gallery_gallery TO nephthys_user;

CREATE SEQUENCE seq_icedreaper_gallery_picture_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_gallery_picture_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_gallery_picture
(
  pictureId integer NOT NULL DEFAULT nextval('seq_icedreaper_gallery_picture_id'::regclass),
  galleryId integer NOT NULL,
  pictureFileName character varying(150) NOT NULL,
  thumbnailFileName character varying(150) NOT NULL,
  title character varying(50),
  alt character varying(50),
  caption character varying(300),
  sortId integer NOT NULL,
  
  CONSTRAINT PK_icedreaper_gallery_picture_id PRIMARY KEY (pictureId),
  CONSTRAINT FK_icedreaper_gallery_picture_galleryId FOREIGN KEY (galleryId) REFERENCES icedreaper_gallery_gallery (galleryId) ON UPDATE NO ACTION ON DELETE CASCADE
) 
WITH (
  OIDS = FALSE
);

CREATE        INDEX FKI_icedreaper_gallery_picture_galleryId  ON icedreaper_gallery_picture(galleryId);
CREATE UNIQUE INDEX UK_icedreaper_gallery_picture_picturePath ON icedreaper_gallery_picture(lower(pictureFileName));

ALTER TABLE icedreaper_gallery_picture OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_gallery_picture TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_gallery_picture TO nephthys_user;


CREATE SEQUENCE seq_icedreaper_gallery_category_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_gallery_category_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_gallery_category
(
  categoryId integer NOT NULL DEFAULT nextval('seq_icedreaper_gallery_category_id'::regclass),
  name character varying(125),
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_gallery_category_id PRIMARY KEY (categoryId),
  CONSTRAINT FK_icedreaper_gallery_category_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_gallery_category_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE UNIQUE INDEX UK_icedreaper_gallery_category_name ON icedreaper_gallery_category(lower(name));

ALTER TABLE icedreaper_gallery_category OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_gallery_category TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_gallery_category TO nephthys_user;

CREATE SEQUENCE seq_icedreaper_gallery_galleryCategory_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_gallery_category_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_gallery_galleryCategory
(
  galleryCategoryId integer NOT NULL DEFAULT nextval('seq_icedreaper_gallery_gallerycategory_id'::regclass),
  galleryId integer NOT NULL,
  categoryId integer NOT NULL,
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_gallery_galleryCategory_id PRIMARY KEY (galleryCategoryId),
  CONSTRAINT UK_icedreaper_gallery_galleryCategory_gcId UNIQUE (galleryId, categoryId),
  CONSTRAINT FK_icedreaper_gallery_galleryCategory_creatorUserId FOREIGN KEY (creatorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_gallery_galleryCategory_galleryId     FOREIGN KEY (galleryId)     REFERENCES icedreaper_gallery_gallery  (galleryId)  ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_icedreaper_gallery_galleryCategory_categoryId    FOREIGN KEY (categoryId)    REFERENCES icedreaper_gallery_category (categoryId) ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS = FALSE
);

ALTER TABLE icedreaper_gallery_galleryCategory OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_gallery_galleryCategory TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_gallery_galleryCategory TO nephthys_user;

CREATE SEQUENCE seq_icedreaper_gallery_statistics_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_gallery_statistics_id OWNER TO nephthys_admin;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE seq_icedreaper_gallery_statistics_id TO nephthys_user;

CREATE TABLE public.icedreaper_gallery_statistics
(
  statisticsId integer NOT NULL DEFAULT nextval('seq_icedreaper_gallery_statistics_id'::regclass),
  galleryId    integer NOT NULL,
  openDate     timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_gallery_statistics_id PRIMARY KEY (statisticsId),
  CONSTRAINT FK_icedreaper_gallery_statistics_galleryId FOREIGN KEY (galleryId) REFERENCES icedreaper_gallery_gallery (galleryId) ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS = FALSE
);

CREATE INDEX FKI_icedreaper_gallery_statistics_galleryId  ON icedreaper_gallery_statistics(galleryId);

ALTER TABLE icedreaper_gallery_statistics OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_gallery_statistics TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE icedreaper_gallery_statistics TO nephthys_user;