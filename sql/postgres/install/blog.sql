CREATE TABLE public.icedreaper_blog_settings
(
  commentingActivated boolean NOT NULL DEFAULT FALSE,
  anonymousCommenting boolean NOT NULL DEFAULT FALSE,
  commentsNeedPublished boolean NOT NULL DEFAULT TRUE
)
WITH (
  OIDS=FALSE
);



CREATE SEQUENCE seq_icedreaper_blog_post_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_blog_post_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_blog_post
(
  postId integer NOT NULL DEFAULT nextval('seq_icedreaper_blog_post_id'::regclass),
  headline character varying(100),
  description character varying(500),
  link character varying(150),
  story text,
  published boolean DEFAULT false,
  publishingDate date,
  commentsActivated boolean NOT NULL DEFAULT FALSE,
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  lastEditorUserId integer NOT NULL,
  lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_blog_post_id PRIMARY KEY (postId),
  CONSTRAINT UK_icedreaper_blog_post_headline UNIQUE (lower(headline)),
  CONSTRAINT UK_icedreaper_blog_post_link     UNIQUE (lower(link)),
  CONSTRAINT FK_icedreaper_blog_post_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_blog_post_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
) 
WITH (
  OIDS = FALSE
);

CREATE INDEX FKI_icedreaper_blog_post_creatorUserId    ON icedreaper_blog_post(creatorUserId);
CREATE INDEX FKI_icedreaper_blog_post_lastEditorUserId ON icedreaper_blog_post(lastEditorUserId);
CREATE INDEX IDX_icedreaper_blog_post_published        ON icedreaper_blog_post(published, publishingDate);
CREATE INDEX IDX_icedreaper_blog_post_link             ON icedreaper_blog_post(link);

ALTER TABLE icedreaper_blog_post OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_blog_post TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_blog_post TO nephthys_user;



CREATE SEQUENCE seq_icedreaper_blog_comment_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_blog_comment_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_blog_comment
(
  commentId integer NOT NULL DEFAULT nextval('seq_icedreaper_blog_comment_id'::regclass),
  postId integer NOT NULL,
  parentCommentId integer,
  headline character varying(50),
  comment character varying(500),
  creatorUserId integer NOT NULL,
  creationDate timestamp with time zone NOT NULL DEFAULT now(),
  published boolean NOT NULL DEFAULT FALSE,
  publishedUserId integer,
  publishedDate timestamp with time zone,
  
  CONSTRAINT PK_icedreaper_blog_comment_id PRIMARY KEY (commentId),
  CONSTRAINT FK_icedreaper_blog_comment_postId          FOREIGN KEY (postId)          REFERENCES icedreaper_blog_post    (postId)    ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_icedreaper_blog_comment_parentCommentId FOREIGN KEY (parentCommentId) REFERENCES icedreaper_blog_comment (commentId) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_icedreaper_blog_comment_creatorUserId   FOREIGN KEY (creatorUserId)   REFERENCES nephthys_user           (userid)    ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT FK_icedreaper_blog_comment_publishedUserId FOREIGN KEY (publishedUserId) REFERENCES nephthys_user           (userid)    ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE INDEX FKI_icedreaper_blog_comment_postId          ON icedreaper_blog_comment(postId);
CREATE INDEX FKI_icedreaper_blog_comment_parentCommentId ON icedreaper_blog_comment(parentCommentId);
CREATE INDEX FKI_icedreaper_blog_comment_creatorUserId   ON icedreaper_blog_comment(creatorUserId);
CREATE INDEX FKI_icedreaper_blog_comment_publishedUserId ON icedreaper_blog_comment(publishedUserId);
CREATE INDEX IDX_icedreaper_blog_comment_published       ON icedreaper_blog_comment(published, publishingDate);

ALTER TABLE icedreaper_blog_comment OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_blog_comment TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_blog_comment TO nephthys_user;



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
  
  CONSTRAINT PK_icedreaper_blog_category_id PRIMARY KEY (categoryId),
  CONSTRAINT UK_icedreaper_blog_category_name UNIQUE (lower(name))
)
WITH (
  OIDS = FALSE
);

CREATE INDEX IDX_icedreaper_blog_category_name ON icedreaper_blog_category(name);

ALTER TABLE icedreaper_blog_category OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_blog_category TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_blog_category TO nephthys_user;



CREATE SEQUENCE seq_icedreaper_blog_postCategory_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_blog_postCategory_id OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_blog_postCategory
(
  postCategoryId integer NOT NULL DEFAULT nextval('seq_icedreaper_blog_category_id'::regclass),
  postId integer NOT NULL,
  categoryId integer NOT NULL,
  setByUserId integer NOT NULL,
  setDate timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_icedreaper_blog_postCategory_id PRIMARY KEY (postCategoryId),
  CONSTRAINT FK_icedreaper_blog_postCategory_postId      FOREIGN KEY (postId)      REFERENCES icedreaper_blog_post     (postId)     ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_icedreaper_blog_postCategory_categoryId  FOREIGN KEY (categoryId)  REFERENCES icedreaper_blog_category (categoryId) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_icedreaper_blog_postCategory_setByUserId FOREIGN KEY (setByUserId) REFERENCES nephthys_user            (userId)     ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS = FALSE
);

CREATE INDEX FKI_icedreaper_blog_postCategory_postId         ON icedreaper_blog_postCategory(postId);
CREATE INDEX FKI_icedreaper_blog_postCategory_categoryId     ON icedreaper_blog_postCategory(categoryId);
CREATE INDEX IDX_icedreaper_blog_postCategory_postCategoryId ON icedreaper_blog_postCategory(postId, categoryId);

ALTER TABLE icedreaper_blog_postCategory OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_blog_postCategory TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_blog_postCategory TO nephthys_user;