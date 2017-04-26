CREATE TABLE "burden_estimate_set" (
"id"  SERIAL NOT NULL ,
"model_version" INTEGER NOT NULL ,
"responsibility" INTEGER NOT NULL ,
"run_info" TEXT NOT NULL ,
"validation" TEXT ,
"comment" TEXT ,
"interpolated" BOOLEAN NOT NULL ,
"complete" BOOLEAN NOT NULL DEFAULT 'False' ,
"uploaded_by" TEXT NOT NULL ,
"uploaded_on" TIMESTAMP NOT NULL DEFAULT 'current_timestamp' ,
PRIMARY KEY ("id")
);

CREATE TABLE "burden_estimate" (
"id"  SERIAL ,
"burden_estimate_set" INTEGER NOT NULL ,
"country" TEXT NOT NULL ,
"year" INTEGER NOT NULL ,
"outcome" INTEGER ,
"stochastic" BOOLEAN NOT NULL ,
"value" DECIMAL ,
PRIMARY KEY ("id")
);

CREATE TABLE "vaccine" (
"id" TEXT NOT NULL DEFAULT 'NULL' ,
"name" TEXT NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "model" (
"id" TEXT NOT NULL ,
"modelling_group" TEXT NOT NULL DEFAULT 'NULL' ,
"description" TEXT NOT NULL ,
"citation" TEXT NOT NULL ,
"current" TEXT ,
PRIMARY KEY ("id")
);
COMMENT ON TABLE "model" IS 'With the self-referencing "current" field; we consider a model to be the current one if current is null.  See comment about recursion in modelling_group';

CREATE TABLE "outcome" (
"id"  SERIAL ,
"code" TEXT NOT NULL ,
"name" VARCHAR(32) NOT NULL ,
PRIMARY KEY ("id"),
UNIQUE ("code")
);

CREATE TABLE "country" (
"id" TEXT NOT NULL ,
"name" VARCHAR(32) NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "coverage" (
"id"  SERIAL ,
"coverage_set" INTEGER NOT NULL ,
"year" INTEGER ,
"country" TEXT ,
"age_from" DECIMAL NOT NULL ,
"age_to" DECIMAL NOT NULL ,
"age_to_exclusive" BOOLEAN NOT NULL ,
"age_range_verbatim" TEXT ,
"coverage" DECIMAL ,
"gavi_support" BOOLEAN NOT NULL ,
"activity" TEXT ,
PRIMARY KEY ("id")
);

CREATE TABLE "disease" (
"id" TEXT NOT NULL ,
"name" VARCHAR NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "model_version" (
"id"  SERIAL ,
"model" TEXT NOT NULL ,
"version" TEXT NOT NULL ,
"note" TEXT ,
"fingerprint" TEXT ,
PRIMARY KEY ("id"),
UNIQUE ("model", "version")
);

CREATE TABLE "touchstone" (
"id" TEXT NOT NULL ,
"touchstone_name" TEXT NOT NULL ,
"version" INTEGER NOT NULL ,
"description" TEXT NOT NULL ,
"status" TEXT NOT NULL ,
"year_start" INTEGER NOT NULL ,
"year_end" INTEGER NOT NULL ,
PRIMARY KEY ("id"),
UNIQUE ("touchstone_name", "version")
);
COMMENT ON TABLE "touchstone" IS 'This is the top-level categorization. It refers to an Operational Forecast from GAVI, a WUENIC July update, or some other data set against which impact estimates are going to be done ';

CREATE TABLE "activity_type" (
"id" TEXT NOT NULL DEFAULT 'NULL' ,
"name" VARCHAR(255) NOT NULL DEFAULT 'NULL' ,
PRIMARY KEY ("id")
);
COMMENT ON TABLE "activity_type" IS 'This is mostly "none", "routine" or "campaign" but with a few extras';

CREATE TABLE "gavi_support_level" (
"id" TEXT NOT NULL ,
"name" VARCHAR(255) NOT NULL DEFAULT 'NULL' ,
PRIMARY KEY ("id")
);
COMMENT ON TABLE "gavi_support_level" IS 'Enum table. Possible values: none (No vaccination), without (Vaccination without GAVI support), with (Vaccination with GAVI support)';

CREATE TABLE "scenario" (
"id"  SERIAL ,
"touchstone" TEXT NOT NULL DEFAULT 'NULL' ,
"scenario_description" TEXT NOT NULL ,
PRIMARY KEY ("id"),
UNIQUE ("touchstone", "scenario_description")
);

CREATE TABLE "coverage_set" (
"id"  SERIAL NOT NULL ,
"name" TEXT NOT NULL ,
"touchstone" TEXT NOT NULL ,
"vaccine" TEXT NOT NULL ,
"gavi_support_level" TEXT NOT NULL ,
"activity_type" TEXT NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "modelling_group" (
"id" TEXT NOT NULL ,
"description" TEXT NOT NULL ,
"current" TEXT ,
PRIMARY KEY ("id")
);
COMMENT ON TABLE "modelling_group" IS 'With the self-referencing "current" field; we consider a modelling group to be the current one if current is null.  This is not recursive; if we move a modelling group to a new id then every modelling group that has current pointing at the old id must be updated to point at the new one.  This means that no `current` points at an `id` that does not have `current` as `null`.';

CREATE TABLE "responsibility" (
"id"  SERIAL NOT NULL ,
"responsibility_set" INTEGER NOT NULL ,
"scenario" INTEGER NOT NULL ,
PRIMARY KEY ("id"),
UNIQUE ("responsibility_set", "scenario")
);

CREATE TABLE "scenario_description" (
"id" TEXT NOT NULL ,
"description" TEXT NOT NULL ,
"disease" TEXT NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "responsibility_set" (
"id"  SERIAL NOT NULL ,
"modelling_group" TEXT NOT NULL ,
"touchstone" TEXT NOT NULL ,
"status" TEXT NOT NULL ,
PRIMARY KEY ("id"),
UNIQUE ("modelling_group", "touchstone")
);

CREATE TABLE "scenario_coverage_set" (
"id"  SERIAL ,
"scenario" INTEGER NOT NULL ,
"coverage_set" INTEGER NOT NULL ,
"order" INTEGER NOT NULL ,
PRIMARY KEY ("id"),
UNIQUE ("scenario", "order")
);

CREATE TABLE "touchstone_country" (
"id"  SERIAL ,
"touchstone" TEXT NOT NULL ,
"country" TEXT NOT NULL ,
"who_region" TEXT NOT NULL DEFAULT 'NULL' ,
"gavi73" BOOLEAN NOT NULL ,
"wuenic" BOOLEAN NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "touchstone_status" (
"id" TEXT NOT NULL ,
"name" TEXT NOT NULL ,
PRIMARY KEY ("id")
);
COMMENT ON TABLE "touchstone_status" IS 'Valid values: {in-preparation, open, finished}';

CREATE TABLE "responsibility_set_status" (
"id" TEXT NOT NULL ,
"name" TEXT NOT NULL ,
PRIMARY KEY ("id")
);
COMMENT ON TABLE "responsibility_set_status" IS 'Possible values {incomplete, submitted, approved}';

CREATE TABLE "app_user" (
"username" TEXT NOT NULL ,
"name" TEXT ,
"email" TEXT ,
"password_hash" TEXT ,
"salt" TEXT ,
"last_logged_in" TIMESTAMP ,
PRIMARY KEY ("username")
);

CREATE TABLE "permission" (
"name" TEXT NOT NULL ,
PRIMARY KEY ("name")
);

CREATE TABLE "role" (
"id"  SERIAL ,
"name" TEXT NOT NULL ,
"scope_prefix" TEXT ,
"description" TEXT NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "user_role" (
"username" TEXT NOT NULL ,
"role" INTEGER ,
"scope_id" TEXT ,
PRIMARY KEY ("username", "role", "scope_id")
);

CREATE TABLE "role_permission" (
"role" INTEGER ,
"permission" TEXT NOT NULL ,
PRIMARY KEY ("role", "permission")
);

CREATE TABLE "touchstone_name" (
"id" TEXT NOT NULL ,
"description" TEXT NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "impact_estimate_calculation" (
"id"  SERIAL ,
"version" INTEGER NOT NULL ,
"name" TEXT ,
"script" TEXT NOT NULL ,
"comment" TEXT NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "impact_estimate_component" (
"id"  SERIAL ,
"responsibility" INTEGER NOT NULL ,
"impact_estimate" INTEGER NOT NULL ,
"outcome" INTEGER ,
"name" TEXT NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "impact_estimate" (
"id"  SERIAL ,
"impact_estimate_set" INTEGER ,
"year" INTEGER ,
"country" TEXT NOT NULL ,
"value" DECIMAL NOT NULL ,
PRIMARY KEY ("id")
);

CREATE TABLE "impact_estimate_set" (
"id"  SERIAL ,
"impact_estimate_component" INTEGER ,
"impact_estimate_calculation" INTEGER ,
"burden_estimate_set" INTEGER ,
PRIMARY KEY ("id")
);

ALTER TABLE "burden_estimate_set" ADD FOREIGN KEY ("model_version") REFERENCES "model_version" ("id");
ALTER TABLE "burden_estimate_set" ADD FOREIGN KEY ("responsibility") REFERENCES "responsibility" ("id");
ALTER TABLE "burden_estimate_set" ADD FOREIGN KEY ("uploaded_by") REFERENCES "app_user" ("username");
ALTER TABLE "burden_estimate" ADD FOREIGN KEY ("burden_estimate_set") REFERENCES "burden_estimate_set" ("id");
ALTER TABLE "burden_estimate" ADD FOREIGN KEY ("country") REFERENCES "country" ("id");
ALTER TABLE "burden_estimate" ADD FOREIGN KEY ("outcome") REFERENCES "outcome" ("id");
ALTER TABLE "model" ADD FOREIGN KEY ("modelling_group") REFERENCES "modelling_group" ("id");
ALTER TABLE "model" ADD FOREIGN KEY ("current") REFERENCES "model" ("id");
ALTER TABLE "coverage" ADD FOREIGN KEY ("coverage_set") REFERENCES "coverage_set" ("id");
ALTER TABLE "coverage" ADD FOREIGN KEY ("country") REFERENCES "country" ("id");
ALTER TABLE "model_version" ADD FOREIGN KEY ("model") REFERENCES "model" ("id");
ALTER TABLE "touchstone" ADD FOREIGN KEY ("touchstone_name") REFERENCES "touchstone_name" ("id");
ALTER TABLE "touchstone" ADD FOREIGN KEY ("status") REFERENCES "touchstone_status" ("id");
ALTER TABLE "scenario" ADD FOREIGN KEY ("touchstone") REFERENCES "touchstone" ("id");
ALTER TABLE "scenario" ADD FOREIGN KEY ("scenario_description") REFERENCES "scenario_description" ("id");
ALTER TABLE "coverage_set" ADD FOREIGN KEY ("touchstone") REFERENCES "touchstone" ("id");
ALTER TABLE "coverage_set" ADD FOREIGN KEY ("vaccine") REFERENCES "vaccine" ("id");
ALTER TABLE "coverage_set" ADD FOREIGN KEY ("gavi_support_level") REFERENCES "gavi_support_level" ("id");
ALTER TABLE "coverage_set" ADD FOREIGN KEY ("activity_type") REFERENCES "activity_type" ("id");
ALTER TABLE "modelling_group" ADD FOREIGN KEY ("current") REFERENCES "modelling_group" ("id");
ALTER TABLE "responsibility" ADD FOREIGN KEY ("responsibility_set") REFERENCES "responsibility_set" ("id");
ALTER TABLE "responsibility" ADD FOREIGN KEY ("scenario") REFERENCES "scenario" ("id");
ALTER TABLE "scenario_description" ADD FOREIGN KEY ("disease") REFERENCES "disease" ("id");
ALTER TABLE "responsibility_set" ADD FOREIGN KEY ("modelling_group") REFERENCES "modelling_group" ("id");
ALTER TABLE "responsibility_set" ADD FOREIGN KEY ("touchstone") REFERENCES "touchstone" ("id");
ALTER TABLE "responsibility_set" ADD FOREIGN KEY ("status") REFERENCES "responsibility_set_status" ("id");
ALTER TABLE "scenario_coverage_set" ADD FOREIGN KEY ("scenario") REFERENCES "scenario" ("id");
ALTER TABLE "scenario_coverage_set" ADD FOREIGN KEY ("coverage_set") REFERENCES "coverage_set" ("id");
ALTER TABLE "touchstone_country" ADD FOREIGN KEY ("touchstone") REFERENCES "touchstone" ("id");
ALTER TABLE "touchstone_country" ADD FOREIGN KEY ("country") REFERENCES "country" ("id");
ALTER TABLE "user_role" ADD FOREIGN KEY ("username") REFERENCES "app_user" ("username");
ALTER TABLE "user_role" ADD FOREIGN KEY ("role") REFERENCES "role" ("id");
ALTER TABLE "role_permission" ADD FOREIGN KEY ("role") REFERENCES "role" ("id");
ALTER TABLE "role_permission" ADD FOREIGN KEY ("permission") REFERENCES "permission" ("name");
ALTER TABLE "impact_estimate_component" ADD FOREIGN KEY ("responsibility") REFERENCES "responsibility" ("id");
ALTER TABLE "impact_estimate_component" ADD FOREIGN KEY ("impact_estimate") REFERENCES "impact_estimate_calculation" ("id");
ALTER TABLE "impact_estimate_component" ADD FOREIGN KEY ("outcome") REFERENCES "outcome" ("id");
ALTER TABLE "impact_estimate" ADD FOREIGN KEY ("impact_estimate_set") REFERENCES "impact_estimate_set" ("id");
ALTER TABLE "impact_estimate" ADD FOREIGN KEY ("country") REFERENCES "country" ("id");
ALTER TABLE "impact_estimate_set" ADD FOREIGN KEY ("impact_estimate_component") REFERENCES "impact_estimate_component" ("id");
ALTER TABLE "impact_estimate_set" ADD FOREIGN KEY ("impact_estimate_calculation") REFERENCES "impact_estimate_calculation" ("id");
ALTER TABLE "impact_estimate_set" ADD FOREIGN KEY ("burden_estimate_set") REFERENCES "burden_estimate_set" ("id");
