CREATE SEQUENCE seq_icedreaper_contactForm_requestId
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_contactForm_requestId OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_contactForm_request
(
    requestId integer NOT NULL DEFAULT nextval('seq_icedreaper_contactForm_requestId'::regclass),
    subject character varying(300) NOT NULL,
    email character varying(100) NOT NULL,
    message text NOT NULL,
    userName character varying(100) NOT NULL,
    creatorUserId integer DEFAULT NULL,
    creationDate timestamp with time zone NOT NULL DEFAULT now(),
    lastEditorUserId integer,
    lastEditDate timestamp with time zone,
  
    CONSTRAINT PK_icedreaper_contactForm_request_id PRIMARY KEY (requestId),
    CONSTRAINT FK_icedreaper_contactForm_request_creatorUserId    FOREIGN KEY (creatorUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
    CONSTRAINT FK_icedreaper_contactForm_request_lastEditorUserId FOREIGN KEY (lastEditorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);

ALTER TABLE icedreaper_contactForm_request OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_contactForm_request TO nephthys_admin;
GRANT INSERT ON TABLE icedreaper_contactForm_request TO nephthys_user;