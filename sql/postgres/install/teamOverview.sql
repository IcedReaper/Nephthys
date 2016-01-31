CREATE SEQUENCE seq_icedreaper_teamOverview_memberId
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 65535
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_teamOverview_memberId OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_teamOverview_member
(
    memberId integer NOT NULL DEFAULT nextval('seq_icedreaper_teamOverview_memberId'::regclass),
    userId integer NOT NULL,
    sortId integer NOT NULL,
    
    creatorUserId integer NOT NULL,
    creationDate timestamp with time zone NOT NULL DEFAULT now(),
    lastEditorUserId integer NOT NULL,
    lastEditDate timestamp with time zone NOT NULL DEFAULT now(),
    
  
    CONSTRAINT PK_icedreaper_teamOverview_member_id PRIMARY KEY (memberId),
    CONSTRAINT UK_icedreaper_teamOverview_member_sortId UNIQUE (sortId),
    CONSTRAINT UK_icedreaper_teamOverview_member_userId UNIQUE (userId),
    CONSTRAINT FK_icedreaper_teamOverview_member_userId           FOREIGN KEY (userId)           REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT FK_icedreaper_teamOverview_member_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
    CONSTRAINT FK_icedreaper_teamOverview_member_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);

ALTER TABLE icedreaper_teamOverview_member OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_teamOverview_member TO nephthys_admin;
GRANT SELECT ON TABLE icedreaper_teamOverview_member TO nephthys_user;