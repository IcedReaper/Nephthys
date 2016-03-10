/* Game | CD | Movie */
CREATE SEQUENCE seq_icedreaper_review_type_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_review_type_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_review_type
(
  typeId integer NOT NULL DEFAULT nextval('seq_icedreaper_review_type_id'::regclass),
  name character varying(125),
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_review_type_id PRIMARY KEY (typeId),
  CONSTRAINT FK_icedreaper_review_type_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_review_type_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

ALTER TABLE icedreaper_review_type OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_review_type TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_review_type TO nephthys_user;

CREATE SEQUENCE seq_icedreaper_review_reviewId
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_review_reviewId OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_review_review
(
    reviewId integer NOT NULL DEFAULT nextval('seq_icedreaper_review_reviewId'::regclass),
    typeId integer NOT NULL,
    rating numeric(6, 1) NOT NULL DEFAULT 0,
    description character varying(100) NOT NULL,
    headline character varying(100) NOT NULL,
    introduction character varying(500) NOT NULL,
    reviewText text,
    imagePath character varying(255),
    viewCounter integer NOT NULL DEFAULT 0,
    link character varying(50) NOT NULL,
    creatorUserId integer NOT NULL,
    creationDate timestamp with time zone NOT NULL DEFAULT now(),
    lastEditorUserId integer NOT NULL,
    lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
    
    CONSTRAINT PK_icedreaper_review_review_Id PRIMARY KEY (reviewId),
    CONSTRAINT FK_icedreaper_review_review_typeId           FOREIGN KEY (typeId)           REFERENCES icedreaper_review_type (typeId) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_icedreaper_review_review_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid)          ON UPDATE NO ACTION ON DELETE SET NULL,
    CONSTRAINT FK_icedreaper_review_review_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid)          ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);

CREATE        INDEX FKI_IcedReaper_review_review_typeId ON icedreaper_review_review(typeId);
CREATE        INDEX IDX_IcedReaper_review_review_rating ON icedreaper_review_review(rating);
CREATE UNIQUE INDEX IDX_IcedReaper_review_review_link   ON icedreaper_review_review(lower(link));

ALTER TABLE icedreaper_review_review OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_review_review TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_review_review TO nephthys_user;


CREATE SEQUENCE seq_icedreaper_review_genre_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_review_genre_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_review_genre
(
  genreId integer NOT NULL DEFAULT nextval('seq_icedreaper_review_genre_id'::regclass),
  name character varying(125),
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_review_genre_id PRIMARY KEY (genreId),
  CONSTRAINT FK_icedreaper_review_genre_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_review_genre_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE UNIQUE INDEX UK_icedreaper_review_genre_name ON icedreaper_review_genre(lower(name));

ALTER TABLE icedreaper_review_genre OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_review_genre TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_review_genre TO nephthys_user;

CREATE SEQUENCE seq_icedreaper_review_reviewgenre_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_review_genre_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_review_reviewgenre
(
  reviewgenreId integer NOT NULL DEFAULT nextval('seq_icedreaper_review_reviewgenre_id'::regclass),
  reviewId integer NOT NULL,
  genreId integer NOT NULL,
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_review_reviewgenre_id PRIMARY KEY (reviewgenreId),
  CONSTRAINT UK_icedreaper_review_reviewgenre_gcId UNIQUE (reviewId, genreId),
  CONSTRAINT FK_icedreaper_review_reviewgenre_creatorUserId FOREIGN KEY (creatorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_review_reviewgenre_reviewId     FOREIGN KEY (reviewId)     REFERENCES icedreaper_review_review  (reviewId)  ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_icedreaper_review_reviewgenre_genreId    FOREIGN KEY (genreId)    REFERENCES icedreaper_review_genre (genreId) ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS = FALSE
);

ALTER TABLE icedreaper_review_reviewgenre OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_review_reviewgenre TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_review_reviewgenre TO nephthys_user;

CREATE SEQUENCE seq_icedreaper_review_statistics_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_review_statistics_id OWNER TO nephthys_admin;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE seq_icedreaper_review_statistics_id TO nephthys_user;

CREATE TABLE public.icedreaper_review_statistics
(
  statisticsId integer NOT NULL DEFAULT nextval('seq_icedreaper_review_statistics_id'::regclass),
  reviewId     integer NOT NULL,
  openDate     timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_review_statistics_id PRIMARY KEY (statisticsId),
  CONSTRAINT FK_icedreaper_review_statistics_reviewId FOREIGN KEY (reviewId) REFERENCES icedreaper_review_review (reviewId) ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS = FALSE
);

CREATE INDEX FKI_icedreaper_review_statistics_reviewId  ON icedreaper_review_statistics(reviewId);

ALTER TABLE icedreaper_review_statistics OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_review_statistics TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE icedreaper_review_statistics TO nephthys_user;