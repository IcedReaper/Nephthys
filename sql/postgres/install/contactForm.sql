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
    read boolean DEFAULT FALSE NOT NULL,
    readDate timestamp with time zone,
    readUserId integer DEFAULT NULL,
    requestorUserId integer DEFAULT NULL,
    requestDate timestamp with time zone NOT NULL DEFAULT now(),
  
    CONSTRAINT PK_icedreaper_contactForm_request_id PRIMARY KEY (requestId),
    CONSTRAINT FK_icedreaper_contactForm_request_requestorUserId FOREIGN KEY (requestorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL,
    CONSTRAINT FK_icedreaper_contactForm_request_readUserId    FOREIGN KEY (readUserId)    REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);

CREATE INDEX IDX_icedreaper_contactForm_request_read ON icedreaper_contactForm_request(read);

ALTER TABLE icedreaper_contactForm_request OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_contactForm_request TO nephthys_admin;
GRANT INSERT ON TABLE icedreaper_contactForm_request TO nephthys_user;

CREATE SEQUENCE seq_icedreaper_contactForm_replyId
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_icedreaper_contactForm_replyId OWNER TO nephthys_admin;

CREATE TABLE public.icedreaper_contactForm_reply
(
    replyId integer NOT NULL DEFAULT nextval('seq_icedreaper_contactForm_replyId'::regclass),
    requestId integer NOT NULL,
    message text NOT NULL,
    replyUserId integer DEFAULT NULL,
    replyDate timestamp with time zone NOT NULL DEFAULT now(),
  
    CONSTRAINT PK_icedreaper_contactForm_reply_id PRIMARY KEY (replyId),
    CONSTRAINT FK_icedreaper_contactForm_reply_requestId   FOREIGN KEY (requestId)   REFERENCES icedreaper_contactForm_request (requestId) ON UPDATE NO ACTION ON DELETE SET NULL,
    CONSTRAINT FK_icedreaper_contactForm_reply_replyUserId FOREIGN KEY (replyUserId) REFERENCES nephthys_user (userid)                     ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);

ALTER TABLE icedreaper_contactForm_reply OWNER TO nephthys_admin;

GRANT ALL    ON TABLE icedreaper_contactForm_reply TO nephthys_admin;
GRANT INSERT ON TABLE icedreaper_contactForm_reply TO nephthys_user;