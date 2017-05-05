/* Drop Tables */
DROP VIEW IF EXISTS domain_lookup_average_duration;
DROP TABLE IF EXISTS lookup CASCADE;
DROP TABLE IF EXISTS lookup_entity CASCADE;
DROP TABLE IF EXISTS domain CASCADE;
DROP TABLE IF EXISTS domain_type CASCADE;
DROP TABLE IF EXISTS domain_lookup CASCADE;
DROP TABLE IF EXISTS domain_lookup_state CASCADE;
DROP TABLE IF EXISTS error_log CASCADE;

--------------------------------------------------------------------------------

/* Create Tables */

CREATE TABLE lookup
(
	id BIGSERIAL NOT NULL,
	lookup_entity_id BIGINT NOT NULL,
	date TIMESTAMP(6) NOT NULL,
	email VARCHAR(255) NULL,

	CONSTRAINT pk_lookup PRIMARY KEY (id)
);

CREATE TABLE domain_lookup
(
	id BIGSERIAL NOT NULL,

	submitted_date TIMESTAMP(6) NOT NULL,
	completed_date TIMESTAMP(6),

	negative_count BIGINT,
	neutral_count BIGINT,
	positive_count BIGINT,

	negativity_percentage REAL,
	neutrality_percentage REAL,
	positivity_percentage REAL,

	domain_lookup_state_code SMALLINT NOT NULL,
	lookup_id BIGINT NOT NULL,
	domain_code SMALLINT NOT NULL,

	CONSTRAINT pk_domain_lookup PRIMARY KEY (id)
);

CREATE TABLE lookup_entity
(
	id BIGSERIAL NOT NULL,
	name VARCHAR(255) NOT NULL,

	CONSTRAINT pk_lookup_entity PRIMARY KEY (id)
);

CREATE TABLE domain_type
(
	code SMALLINT NOT NULL,
	name VARCHAR(150) NOT NULL,

	CONSTRAINT pk_domain_type PRIMARY KEY (code)
);

CREATE TABLE domain
(
	code SMALLINT NOT NULL,
	name VARCHAR(150) NOT NULL,
	active BOOLEAN DEFAULT TRUE NOT NULL,

	domain_type_code SMALLINT NOT NULL,

	CONSTRAINT pk_domain PRIMARY KEY (code)
);

CREATE TABLE domain_lookup_state
(
	code SMALLINT NOT NULL,
	name VARCHAR(150) NOT NULL,

	CONSTRAINT pk_lookup_state PRIMARY KEY (code)
);

CREATE TABLE error_log
(
	id BIGSERIAL NOT NULL,
	date TIMESTAMP(6) NOT NULL,
	source VARCHAR(400) NOT NULL,
	message VARCHAR(400) NOT NULL,
	stack_trace TEXT NOT NULL,

	CONSTRAINT pk_error_log PRIMARY KEY (id)
);

CREATE OR REPLACE VIEW domain_lookup_average_duration
AS (
    WITH domains_with_averages AS
     (SELECT dl_duration.code, dl_duration.name, round(AVG(dl_duration.duration_seconds))::integer AS average_duration_seconds
        FROM (
            SELECT domain.code, domain.name, round((EXTRACT(epoch FROM domain_lookup.completed_date - domain_lookup.submitted_date))::numeric) AS duration_seconds
            FROM domain INNER JOIN domain_lookup
                ON domain.code = domain_lookup.domain_code
            WHERE submitted_date IS NOT NULL
                AND completed_date IS NOT NULL
                AND domain_lookup.domain_lookup_state_code = 3
        ) AS dl_duration
        GROUP BY (dl_duration.code, dl_duration.name))
    SELECT * 
    FROM domains_with_averages
    UNION
    SELECT domain.code, domain.name, NULL AS average_duration_seconds
    FROM domain WHERE domain.code NOT IN (SELECT code FROM domains_with_averages)
);

--------------------------------------------------------------------------------
 
/* Create Foreign Key Constraints */

ALTER TABLE domain_lookup
ADD CONSTRAINT fk_domain_lookup_domain_lookup_state
FOREIGN KEY (domain_lookup_state_code)
	REFERENCES domain_lookup_state (code);

ALTER TABLE lookup
ADD CONSTRAINT fk_lookup_lookup_entity
	FOREIGN KEY (lookup_entity_id)
		REFERENCES lookup_entity(id);

-------------

ALTER TABLE domain_lookup
ADD CONSTRAINT fk_domain_lookup_domain
FOREIGN KEY (domain_code)
	REFERENCES domain (code);

-------------

ALTER TABLE domain
ADD CONSTRAINT fk_domain_domain_type
FOREIGN KEY (domain_type_code)
	REFERENCES domain_type (code);

------------------------------------------------------------------------------
 

/* Create Indexes, Uniques, Checks, Triggers */

-- TODO: Margus

---------------------------------------------------------------------------	

/* Classifier values */

INSERT INTO domain_lookup_state (code, name)
VALUES (1, 'Queued');

INSERT INTO domain_lookup_state(code, name)
VALUES (2, 'In progress');

INSERT INTO domain_lookup_state(code, name)
VALUES (3, 'Complete');

INSERT INTO domain_lookup_state(code, name)
VALUES (4, 'Error');

-------------

INSERT INTO domain_type (code, name)
VALUES (1, 'Search Engine');

INSERT INTO domain_type (code, name)
VALUES (2, 'Social Media');

INSERT INTO domain_type (code, name) 
VALUES (3, 'Message Board');

-------------

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (1, 'Google', TRUE, 1);

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (2, 'Bing', TRUE, 1);

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (3, 'Yahoo', TRUE, 1);

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (4, 'Facebook', FALSE, 2);

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (5, 'Twitter', TRUE, 2);

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (6, 'reddit', TRUE, 3);

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (7, '4chan', TRUE, 3);

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (8, 'tumblr', FALSE, 3);

INSERT INTO domain (code, name, active, domain_type_code)
VALUES (9, 'DuckDuckGo', FALSE, 1);

-------------

---------------------------------------------------------------------------

