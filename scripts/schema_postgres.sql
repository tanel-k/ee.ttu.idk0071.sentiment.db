/* Drop Tables */

DROP TABLE IF EXISTS sentiment_snapshot CASCADE;
DROP TABLE IF EXISTS lookup CASCADE;
DROP TABLE IF EXISTS lookup_entity CASCADE;
DROP TABLE IF EXISTS lookup_domain CASCADE;
DROP TABLE IF EXISTS sentiment_type CASCADE;
DROP TABLE IF EXISTS lookup_state CASCADE;

--------------------------------------------------------------------------------

/* Create Tables */

CREATE TABLE lookup
(
	id BIGSERIAL NOT NULL,
	lookup_entity_id BIGINT NOT NULL,
	date TIMESTAMP(6) NOT NULL,

	sentiment_type_code CHAR(3) NULL,
	lookup_state_code SMALLINT NOT NULL,

	CONSTRAINT pk_lookup PRIMARY KEY (id)
);

CREATE TABLE sentiment_snapshot
(
	id BIGSERIAL NOT NULL,
	url VARCHAR(1000) NOT NULL,
	title VARCHAR(255) NOT NULL,
	date TIMESTAMP(6) NOT NULL,
	trust_level FLOAT(50) NOT NULL,

	lookup_id BIGINT NOT NULL,
	lookup_domain_code SMALLINT NOT NULL,
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

CREATE TABLE lookup_state
(
	code SMALLINT NOT NULL,
	name VARCHAR(150) NOT NULL,

	CONSTRAINT pk_lookup_state PRIMARY KEY (code)
);

--------------------------------------------------------------------------------
 
/* Create Foreign Key Constraints */

ALTER TABLE lookup
ADD CONSTRAINT fk_lookup_sentiment_type
FOREIGN KEY (sentiment_type_code)
	REFERENCES sentiment_type (code);

ALTER TABLE lookup
ADD CONSTRAINT fk_lookup_lookup_state
FOREIGN KEY (lookup_state_code)
	REFERENCES lookup_state (code);

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
FOREIGN KEY (lookup_domain_code)
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

/* Classifier values */

INSERT INTO lookup_state (code, name)
VALUES (1, 'Queued');

INSERT INTO lookup_state(code, name)
VALUES (2, 'In progress');

INSERT INTO lookup_state(code, name)
VALUES (3, 'Complete');

-------------

INSERT INTO lookup_domain (code, name)
VALUES (1, 'Google');

-------------

INSERT INTO sentiment_type (code, name)
VALUES ('NEU', 'Neutral');

INSERT INTO sentiment_type (code, name)
VALUES ('POS', 'Positive');

INSERT INTO sentiment_type (code, name)
VALUES ('NEG', 'Negative');

---------------------------------------------------------------------------

