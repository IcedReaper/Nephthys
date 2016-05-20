CREATE SEQUENCE seq_IcedReaper_privateMessage_conversationId
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_IcedReaper_privateMessage_conversationId OWNER TO nephthys_admin;

CREATE TABLE public.IcedReaper_privateMessage_conversation
(
  conversationId  integer NOT NULL DEFAULT nextval('seq_IcedReaper_privateMessage_conversationId'::regclass),
  initiatorUserId integer NOT NULL,
  startDate       timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_IcedReaper_privateMessage_conversationId PRIMARY KEY (conversationId),
  CONSTRAINT FK_IcedReaper_privateMessage_initiatorUserId FOREIGN KEY (initiatorUserId) REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);

CREATE INDEX IDX_IcedReaper_privateMessage_conversation_startDate ON IcedReaper_privateMessage_conversation(startDate);

GRANT SELECT, UPDATE ON SEQUENCE seq_IcedReaper_privateMessage_conversationId TO nephthys_user;
GRANT SELECT, INSERT ON TABLE IcedReaper_privateMessage_conversation TO nephthys_user;



CREATE SEQUENCE seq_IcedReaper_privateMessage_participantId
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_IcedReaper_privateMessage_participantId OWNER TO nephthys_admin;

CREATE TABLE public.IcedReaper_privateMessage_participant
(
  participantId  integer NOT NULL DEFAULT nextval('seq_IcedReaper_privateMessage_participantId'::regclass),
  conversationId integer NOT NULL,
  userId         integer NOT NULL,
  added          timestamp with time zone NOT NULL DEFAULT now(),
  
  CONSTRAINT PK_IcedReaper_privateMessage_participantId PRIMARY KEY (participantId),
  CONSTRAINT FK_icedreaper_privateMessage_participant_conversationId FOREIGN KEY (conversationId) REFERENCES IcedReaper_privateMessage_conversation (conversationId) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_IcedReaper_privateMessage_participant_participantId  FOREIGN KEY (userId)         REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT UK_IcedReaper_privateMessage_participant_participant UNIQUE (conversationId, userId)
)
WITH (
  OIDS=FALSE
);

CREATE INDEX FKI_IcedReaper_privateMessage_participant_conversationId ON IcedReaper_privateMessage_participant(conversationId);
CREATE INDEX FKI_IcedReaper_privateMessage_participant_userId ON IcedReaper_privateMessage_participant(userId);

CREATE INDEX IDX_IcedReaper_privateMessage_participant_participant ON IcedReaper_privateMessage_participant(conversationId, userId);

GRANT SELECT, UPDATE ON SEQUENCE seq_IcedReaper_privateMessage_participantId TO nephthys_user;
GRANT SELECT, INSERT, DELETE ON TABLE IcedReaper_privateMessage_participant TO nephthys_user;



CREATE SEQUENCE seq_IcedReaper_privateMessage_messageId
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_IcedReaper_privateMessage_messageId OWNER TO nephthys_admin;

CREATE TABLE public.IcedReaper_privateMessage_message
(
  messageId  integer NOT NULL DEFAULT nextval('seq_IcedReaper_privateMessage_messageId'::regclass),
  conversationId integer NOT NULL,
  userId         integer NOT NULL,
  sendDate       timestamp with time zone NOT NULL DEFAULT now(),
  deleteDate     timestamp with time zone DEFAULT NULL,
  message        text NOT NULL,
  
  CONSTRAINT PK_IcedReaper_privateMessage_messageId PRIMARY KEY (messageId),
  CONSTRAINT FK_icedreaper_privateMessage_message_conversationId FOREIGN KEY (conversationId) REFERENCES IcedReaper_privateMessage_conversation (conversationId) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT FK_IcedReaper_privateMessage_message_userId         FOREIGN KEY (userId)         REFERENCES nephthys_user (userid) ON UPDATE NO ACTION ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);

CREATE INDEX FKI_IcedReaper_privateMessage_message_conversationId ON IcedReaper_privateMessage_message(conversationId);
CREATE INDEX FKI_IcedReaper_privateMessage_message_userId         ON IcedReaper_privateMessage_message(userId);

GRANT SELECT, UPDATE ON SEQUENCE seq_IcedReaper_privateMessage_messageId TO nephthys_user;
GRANT SELECT, INSERT, UPDATE ON TABLE IcedReaper_privateMessage_message TO nephthys_user;