CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE "public"."contest_info"("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "content" text NOT NULL, "files" text NOT NULL DEFAULT '"{}"', "title" text NOT NULL, "contest_type" text NOT NULL, PRIMARY KEY ("id") );
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_contest_info_updated_at"
BEFORE UPDATE ON "public"."contest_info"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_contest_info_updated_at" ON "public"."contest_info" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
