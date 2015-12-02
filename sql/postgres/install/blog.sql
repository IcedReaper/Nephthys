DROP TABLE icedreaper_blog_settings;
DROP TABLE icedreaper_blog_comment;
DROP TABLE icedreaper_blog_blogpostCategory;
DROP TABLE icedreaper_blog_blogpost;
DROP TABLE icedreaper_blog_category;

CREATE TABLE public.icedreaper_blog_settings
(
  commentingActivated boolean NOT NULL DEFAULT FALSE,
  anonymousCommenting boolean NOT NULL DEFAULT FALSE,
  commentsNeedPublished boolean NOT NULL DEFAULT TRUE
)
WITH (
  OIDS=FALSE
);



CREATE SEQUENCE seq_icedreaper_blog_blogpost_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_blog_blogpost_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_blog_blogpost
(
  blogpostId integer NOT NULL DEFAULT nextval('seq_icedreaper_blog_blogpost_id'::regclass),
  headline character varying(100),
  link character varying(150),
  story text,
  folderName character varying(150),
  released boolean DEFAULT false,
  releaseDate date DEFAULT NULL,
  commentsActivated boolean NOT NULL DEFAULT FALSE,
  anonymousCommentAllowed boolean NOT NULL DEFAULT FALSE,
  commentsNeedToGetPublished boolean NOT NULL DEFAULT FALSE,
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_blog_blogpost_id PRIMARY KEY (blogpostId),
  CONSTRAINT FK_icedreaper_blog_blogpost_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_blog_blogpost_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
) 
WITH (
  OIDS = FALSE
);

CREATE        INDEX FKI_icedreaper_blog_blogpost_creatorUserId    ON icedreaper_blog_blogpost(creatorUserId);
CREATE        INDEX FKI_icedreaper_blog_blogpost_lastEditorUserId ON icedreaper_blog_blogpost(lastEditorUserId);
CREATE        INDEX IDX_icedreaper_blog_blogpost_released         ON icedreaper_blog_blogpost(released, releaseDate);
CREATE        INDEX IDX_icedreaper_blog_blogpost_link             ON icedreaper_blog_blogpost(link);
CREATE UNIQUE INDEX UK_icedreaper_blog_blogpost_headline          ON icedreaper_blog_blogpost(lower(headline));
CREATE UNIQUE INDEX UK_icedreaper_blog_blogpost_link              ON icedreaper_blog_blogpost(lower(link));
CREATE UNIQUE INDEX UK_icedreaper_blog_blogpost_folderName        ON icedreaper_blog_blogpost(lower(folderName));

ALTER TABLE icedreaper_blog_blogpost OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_blog_blogpost TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_blog_blogpost TO nephthys_user;


CREATE SEQUENCE seq_icedreaper_blog_comment_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_blog_comment_id OWNER TO nephthys_admin;
GRANT SELECT, UPDATE ON SEQUENCE seq_icedreaper_blog_comment_id TO public;

CREATE TABLE public.icedreaper_blog_comment
(
  commentId integer NOT NULL DEFAULT nextval('seq_icedreaper_blog_comment_id'::regclass),
  blogpostId integer NOT NULL,
  /*parentCommentId integer DEFAULT NULL,*/
  comment character varying(500) NOT NULL,
  creatorUserId integer,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  anonymousUsername character varying(50) DEFAULT NULL,
  anonymousEmail character varying(50) DEFAULT NULL,
  published boolean NOT NULL DEFAULT FALSE,
  publishedUserId integer,
  publishedDate timestamp with time zone,
  
  CONSTRAINT PK_icedreaper_blog_comment_id PRIMARY KEY (commentId),
  CONSTRAINT FK_icedreaper_blog_comment_blogpostId      FOREIGN KEY (blogpostId)      REFERENCES icedreaper_blog_blogpost (blogpostId) ON UPDATE NO ACTION ON DELETE CASCADE,
  /*CONSTRAINT FK_icedreaper_blog_comment_parentCommentId FOREIGN KEY (parentCommentId) REFERENCES icedreaper_blog_comment  (commentId)  ON UPDATE NO ACTION ON DELETE CASCADE,*/
  CONSTRAINT FK_icedreaper_blog_comment_creatorUserId   FOREIGN KEY (creatorUserId)   REFERENCES nephthys_user            (userid)     ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_blog_comment_publishedUserId FOREIGN KEY (publishedUserId) REFERENCES nephthys_user            (userid)     ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE INDEX FKI_icedreaper_blog_comment_blogpostId      ON icedreaper_blog_comment(blogpostId);
/*CREATE INDEX FKI_icedreaper_blog_comment_parentCommentId ON icedreaper_blog_comment(parentCommentId);*/
CREATE INDEX FKI_icedreaper_blog_comment_creatorUserId   ON icedreaper_blog_comment(creatorUserId);
CREATE INDEX FKI_icedreaper_blog_comment_publishedUserId ON icedreaper_blog_comment(publishedUserId);
CREATE INDEX IDX_icedreaper_blog_comment_published       ON icedreaper_blog_comment(published, publishedDate);

ALTER TABLE icedreaper_blog_comment OWNER TO nephthys_admin;

GRANT ALL            ON TABLE icedreaper_blog_comment TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE icedreaper_blog_comment TO nephthys_user;



CREATE SEQUENCE seq_icedreaper_blog_category_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_blog_category_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_blog_category
(
  categoryId integer NOT NULL DEFAULT nextval('seq_icedreaper_blog_category_id'::regclass),
  name character varying(25),
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_blog_category_id PRIMARY KEY (categoryId),
  CONSTRAINT FK_icedreaper_blog_category_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_blog_category_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE        INDEX IDX_icedreaper_blog_category_name ON icedreaper_blog_category(name);
CREATE UNIQUE INDEX UK_icedreaper_blog_category_name  ON icedreaper_blog_category(lower(name));

ALTER TABLE icedreaper_blog_category OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_blog_category TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_blog_category TO nephthys_user;



CREATE SEQUENCE seq_icedreaper_blog_blogpostCategory_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_blog_blogpostCategory_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_blog_blogpostCategory
(
  postCategoryId integer NOT NULL DEFAULT nextval('seq_icedreaper_blog_category_id'::regclass),
  blogpostId integer NOT NULL,
  categoryId integer NOT NULL,
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_blog_blogpostCategory_id PRIMARY KEY (postCategoryId),
  CONSTRAINT UK_icedreaper_blog_blogpostCategory_bpCatId UNIQUE (blogpostId, categoryId),
  CONSTRAINT FK_icedreaper_blog_blogpostCategory_blogpostId  FOREIGN KEY (blogpostId)    REFERENCES icedreaper_blog_blogpost (blogpostId) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_icedreaper_blog_blogpostCategory_categoryId  FOREIGN KEY (categoryId)    REFERENCES icedreaper_blog_category (categoryId) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_icedreaper_blog_blogpostCategory_setByUserId FOREIGN KEY (creatorUserId) REFERENCES nephthys_user            (userId)     ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE INDEX FKI_icedreaper_blog_blogpostCategory_blogpostId     ON icedreaper_blog_blogpostCategory(blogpostId);
CREATE INDEX FKI_icedreaper_blog_blogpostCategory_categoryId     ON icedreaper_blog_blogpostCategory(categoryId);
CREATE INDEX IDX_icedreaper_blog_blogpostCategory_postCategoryId ON icedreaper_blog_blogpostCategory(blogpostId, categoryId);

ALTER TABLE icedreaper_blog_blogpostCategory OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_blog_blogpostCategory TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_blog_blogpostCategory TO nephthys_user;

CREATE SEQUENCE seq_icedreaper_blog_statistics_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_blog_statistics_id OWNER TO nephthys_admin;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE seq_icedreaper_blog_statistics_id TO nephthys_user;

CREATE TABLE public.icedreaper_blog_statistics
(
  statisticsId integer NOT NULL DEFAULT nextval('seq_icedreaper_blog_statistics_id'::regclass),
  blogpostId   integer NOT NULL,
  openDate     timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_blog_statistics_id PRIMARY KEY (statisticsId),
  CONSTRAINT FK_icedreaper_blog_statistics_blogpostId FOREIGN KEY (blogpostId) REFERENCES icedreaper_blog_blogpost (blogpostId) ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS = FALSE
);

CREATE INDEX FKI_icedreaper_blog_statistics_blogpostId  ON icedreaper_blog_statistics(blogpostId);

ALTER TABLE icedreaper_blog_statistics OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_blog_statistics TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE icedreaper_blog_statistics TO nephthys_user;