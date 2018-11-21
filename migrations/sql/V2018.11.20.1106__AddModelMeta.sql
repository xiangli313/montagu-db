--- Note for review
--- creating three new table
--- 1. model_version_meta
--- 2. model_version_vaccine
--- 3. model_version_country

COMMENT ON COLUMN model.is_current IS
  'whether the model is currently running for VIMC';

CREATE TABLE model_version_meta (
  id SERIAL,
  model_version INTEGER NOT NULL,
  is_dynamic BOOLEAN NOT NULL, 
  code TEXT,
  dalys BOOLEAN NOT NULL,
  gender INTEGER NOT NULL,
  burden_min_age INTEGER NOT NULL,
  burden_max_age INTEGER NOT NULL,
  cohort_first INTEGER, --- nullable, NA means 2000
  cohort_last INTEGER, --- nullable, NA means min(2100, age_max+2030)
  year_min INTEGER, --- nullable, NA means 2000
  year_max INTEGER, --- nullable, NA means 2100
  PRIMARY KEY (id),
  FOREIGN KEY (model_version) REFERENCES model_version(id),
  FOREIGN KEY (gender) REFERENCES gender(id)
);
COMMENT ON TABLE model_version_meta IS
  'general model metadata, including whether models consider herd effect, how models are coded, whether models provide DALYs, model observation shape - age/cohort/year ranges';

CREATE TABLE model_version_vaccine (
  id SERIAL,
  model_version INTEGER NOT NULL,
  vaccine TEXT NOT NULL, 
  activity_type TEXT NOT NULL, 
  order INTEGER NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (model_version) REFERENCES model_version(id),
  FOREIGN KEY (vaccine) REFERENCES vaccine(id),
  FOREIGN KEY (activity_type) REFERENCES activity_type(id)
);
COMMENT ON TABLE model_version_vaccine IS
  'specify which vaccine deliveries are evaluated in each model';

CREATE TABLE model_version_country (
  id SERIAL,
  model_version INTEGER NOT NULL,
  country TEXT NOT NULL, 
  is_pine BOOLEAN NOT NULL, 
  PRIMARY KEY (id),
  FOREIGN KEY (model_version) REFERENCES model_version(id),
  FOREIGN KEY (country) REFERENCES country(id)
);
COMMENT ON TABLE model_version_country IS
  'specify which countries are evaluated in each model, and which countries are considered in small-scale model run';




