CREATE OR REPLACE FUNCTION updatelasteditdate()
  RETURNS trigger AS
$BODY$
    BEGIN
        NEW.lastEditDate := current_timestamp;
        RETURN NEW;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION updatelasteditdate()
  OWNER TO nephthys_admin;