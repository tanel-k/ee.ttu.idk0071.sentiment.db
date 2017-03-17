/* Drop Tables */

DROP TABLE IF EXISTS sentiment_snapshot CASCADE;
DROP TABLE IF EXISTS lookup CASCADE;
DROP TABLE IF EXISTS lookup_entity CASCADE;
DROP TABLE IF EXISTS lookup_domain CASCADE;
DROP TABLE IF EXISTS sentiment_type CASCADE;
DROP TABLE IF EXISTS lookup_status CASCADE;

--------------------------------------------------------------------------------

/* Create Tables */

CREATE TABLE lookup
(
	id BIGSERIAL NOT NULL,
	lookup_entity_id BIGINT NOT NULL,

	lookup_datetime TIMESTAMP(6) NOT NULL,
	sentiment_type_code CHAR(3) NULL,
	sentiment_lookup_status_code SMALLINT NOT NULL,

	CONSTRAINT pk_lookup PRIMARY KEY (id)
);

CREATE TABLE sentiment_snapshot
(
	id BIGSERIAL NOT NULL,
	url VARCHAR(1000) NOT NULL,
	title VARCHAR(255) NOT NULL,
	snapshot_datetime TIMESTAMP(6) NOT NULL,
	rank SMALLINT NOT NULL,
	trust_level FLOAT(50) NOT NULL,

	lookup_id BIGINT NOT NULL,
	lookup_domain_id SMALLINT NOT NULL,
	sentiment_type_code CHAR(3) NOT NULL,

	CONSTRAINT pk_sentiment_snapshot PRIMARY KEY (id)
);

CREATE TABLE lookup_entity
(
	id BIGSERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,

	CONSTRAINT pk_lookup_entity PRIMARY KEY (id)
);

CREATE TABLE lookup_domain
(
	code SMALLINT NOT NULL,
	name VARCHAR(150) NOT NULL,

	CONSTRAINT pk_sentiment_lookup_domain PRIMARY KEY (code)
);

CREATE TABLE sentiment_type
(
	code CHAR(3) DEFAULT 'NEU' NOT NULL, -- Values: NEU, POS, NEG
	name VARCHAR(150) NULL,

	CONSTRAINT pk_sentiment_type PRIMARY KEY (code)
);

CREATE TABLE lookup_status
(
	code SMALLINT NOT NULL,
	name VARCHAR(150) NOT NULL,

	CONSTRAINT pk_lookup_status PRIMARY KEY (code)
);

--------------------------------------------------------------------------------
 
/* Create Foreign Key Constraints */

ALTER TABLE lookup
ADD CONSTRAINT fk_lookup_sentiment_type
FOREIGN KEY (sentiment_type_code)
	REFERENCES sentiment_type (code);

ALTER TABLE lookup
ADD CONSTRAINT fk_lookup_lookup_status
FOREIGN KEY (sentiment_lookup_status_code)
	REFERENCES lookup_status (code);

ALTER TABLE lookup
ADD CONSTRAINT fk_lookup_lookup_entity
	FOREIGN KEY (lookup_entity_id)
		REFERENCES lookup_entity(id);
-------------
ALTER TABLE sentiment_snapshot
ADD CONSTRAINT fk_lookup_snapshot_lookup
FOREIGN KEY (lookup_id)
	REFERENCES lookup (id);

ALTER TABLE sentiment_snapshot
ADD CONSTRAINT fk_lookup_snapshot_lookup_domain
FOREIGN KEY (lookup_domain_id)
	REFERENCES lookup_domain (code);

ALTER TABLE sentiment_snapshot
ADD CONSTRAINT fk_lookup_snapshot_sentiment_type
FOREIGN KEY (sentiment_type_code)
	REFERENCES sentiment_type (code);
-------------
------------------------------------------------------------------------------
 

/* Create Indexes, Uniques, Checks, Triggers */

-- TODO: Margus

---------------------------------------------------------------------------	