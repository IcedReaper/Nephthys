CREATE SEQUENCE seq_nephthys_statistics_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_statistics_id OWNER TO nephthys_admin;

CREATE TABLE public.nephthys_statistics
(
  statisticsId integer NOT NULL DEFAULT nextval('seq_nephthys_statistics_id'::regclass),
  link character varying(250),
  visitDate timestamp with time zone NOT NULL DEFAULT now(),
  referrer character varying(100),
  
  CONSTRAINT PK_nephthys_statistics_id PRIMARY KEY (statisticsId)
)
WITH (
  OIDS = FALSE
);

CREATE INDEX IDX_nephthys_statistics_link      ON nephthys_statistics(link);
CREATE INDEX IDX_nephthys_statistics_visitDate ON nephthys_statistics(visitDate);

ALTER TABLE nephthys_statistics OWNER TO nephthys_admin;

GRANT ALL            ON TABLE nephthys_statistics TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE nephthys_statistics TO nephthys_user;


CREATE SEQUENCE seq_nephthys_statistics_login_id
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE seq_nephthys_statistics_login_id OWNER TO nephthys_admin;

CREATE TABLE public.nephthys_statistics_login
(
  loginId integer NOT NULL DEFAULT nextVal('seq_nephthys_statistics_login_id'),
  username character varying(200),
  loginDate timestamp with time zone NOT NULL DEFAULT now(),
  successful boolean NOT NULL,
  
  CONSTRAINT PK_nephthys_statistics_login_id PRIMARY KEY (loginId)
)
WITH (
  OIDS = FALSE
);

CREATE INDEX IDX_nephthys_statistics_login_username   ON nephthys_statistics_login(username);
CREATE INDEX IDX_nephthys_statistics_login_loginDate  ON nephthys_statistics_login(loginDate);
CREATE INDEX IDX_nephthys_statistics_login_successful ON nephthys_statistics_login(successful);
CREATE INDEX IDX_nephthys_statistics_login_select     ON nephthys_statistics_login(loginDate, successful);

ALTER TABLE nephthys_statistics_login OWNER TO nephthys_admin;

GRANT ALL            ON TABLE nephthys_statistics_login TO nephthys_admin;
GRANT SELECT, INSERT ON TABLE nephthys_statistics_login TO nephthys_user;
