/* Drop Tables */

begin
	EXECUTE IMMEDIATE 'DROP TABLE   "Sentiment_snapshot" CASCADE CONSTRAINTS';
	EXECUTE IMMEDIATE 'DROP TABLE   "Sentiment_type" CASCADE CONSTRAINTS';
	EXECUTE IMMEDIATE 'DROP TABLE   "Sentiment_lookup" CASCADE CONSTRAINTS';
	EXECUTE IMMEDIATE 'DROP TABLE   "Sentiment_lookup_domain" CASCADE CONSTRAINTS';
	EXECUTE IMMEDIATE 'DROP TABLE   "Sentiment_lookup_status" CASCADE CONSTRAINTS';
	
	EXECUTE IMMEDIATE 'DROP SEQUENCE "sentiment_snapshot_seq"';
	EXECUTE IMMEDIATE 'DROP SEQUENCE "sentiment_type_seq"';
	EXECUTE IMMEDIATE 'DROP SEQUENCE "sentiment_lookup_seq"';
	EXECUTE IMMEDIATE 'DROP SEQUENCE "sentiment_lookup_domain_seq"';
	EXECUTE IMMEDIATE 'DROP SEQUENCE "sentiment_lookup_status_seq"';
	
	EXCEPTION WHEN OTHERS THEN NULL;
end;



--------------------------------------------------------------------------------

/* Create Tables */

CREATE TABLE  "Sentiment_snapshot"
(	"SENTIMENT_SNAPSHOT_ID" NUMBER(8,2) NOT NULL,
	"LOOKUP_ID" NUMBER(8,2) NOT NULL,
	"URL" VARCHAR2(1000) NOT NULL,
	"TITLE" VARCHAR2(255) NOT NULL,
	"SNAPSHOT_DATETIME" TIMESTAMP(6) NOT NULL,
	"SENTIMENT_SNAPSHOT_RANK" NUMBER(8,2) NOT NULL,
	"SENTIMENT_LOOKUP_DOMAIN_CODE" NUMBER(8,2) NULL,
	"TRUST_LEVEL" FLOAT(50) NOT NULL,
	"SENTIMENT_TYPE_CODE" CHAR(3) NULL);

CREATE TABLE  "Sentiment_type"
(	"SENTIMENT_TYPE_CODE" CHAR(3) DEFAULT NEU NOT NULL,    -- Values: NEU, POS, NEG
	"SENTIMENT_TYPE_NAME" VARCHAR2(150) NULL);
	
CREATE TABLE  "Sentiment_lookup"
(	"LOOKUP_ID" NUMBER(8,2) NOT NULL,
	"LOOKUP_DATETIME" TIMESTAMP(6) NOT NULL,
	"SENTIMENT_TYPE_CODE" CHAR(3) NULL,
	"SENTIMENT_LOOKUP_STATUS_CODE" NUMBER(8,2) NOT NULL);

CREATE TABLE  "Sentiment_lookup_domain"
(	"SENTIMENT_LOOKUP_DOMAIN_CODE" NUMBER(8,2) NOT NULL,
	"SENTIMENT_LOOKUP_DOMAIN_NAME" VARCHAR2(150) NOT NULL);	
	
CREATE TABLE  "Sentiment_lookup_status"
(	"SENTIMENT_LOOKUP_STATUS_CODE" NUMBER(8,2) NOT NULL,
	"SENTIMENT_LOOKUP_STATUS_NAME" VARCHAR2(150) NOT NULL);
	
--------------------------------------------------------------------------------

/* Create Primary Keys, Indexes, Uniques, Checks, Triggers */

ALTER TABLE  "Sentiment_snapshot" 
 ADD CONSTRAINT "PK_SENTIMENT_SNAPSHOT"
	PRIMARY KEY ("SENTIMENT_SNAPSHOT_ID") 
 USING INDEX;

CREATE INDEX "IXFK_SENTIMENT_SNAPSHOT_SENTIMENT_LOOKUP"   
 ON  "Sentiment_snapshot" ("LOOKUP_ID") ;

CREATE INDEX "IXFK_SENTIMENT_SNAPSHOT_SENTIMENT_LOOKUP_DOMAIN"   
 ON  "Sentiment_snapshot" ("SENTIMENT_LOOKUP_DOMAIN_CODE");

CREATE INDEX "IXFK_SENTIMENT_SNAPSHOT_SENTIMENT_TYPE"   
 ON  "Sentiment_snapshot" ("SENTIMENT_TYPE_CODE") ;
 -----------

ALTER TABLE  "Sentiment_type" 
 ADD CONSTRAINT "PK_SENTIMENT_TYPE"
	PRIMARY KEY ("SENTIMENT_TYPE_CODE") 
 USING INDEX;
 -----------
 
 ALTER TABLE  "Sentiment_lookup" 
 ADD CONSTRAINT "PK_SENTIMENT_LOOKUP "
	PRIMARY KEY ("LOOKUP_ID") 
 USING INDEX;

CREATE INDEX "IXFK_Sentiment_lo_Sentime01"   
 ON  "Sentiment_lookup" ("SENTIMENT_LOOKUP_STATUS_CODE") ;

CREATE INDEX "IXFK_SENTIMENT_LOOKUP_SENTIMENT_TYPE"   
 ON  "Sentiment_lookup" ("SENTIMENT_TYPE_CODE") ;
 -----------
 
 ALTER TABLE  "Sentiment_lookup_domain" 
 ADD CONSTRAINT "PK_SENTIMENT_LOOKUP_DOMAIN"
	PRIMARY KEY ("SENTIMENT_LOOKUP_DOMAIN_CODE") 
 USING INDEX;
 -----------
 
 ALTER TABLE  "Sentiment_lookup_status" 
 ADD CONSTRAINT "PK_SENTIMENT_LOOKUP_STATUS_CODE"
	PRIMARY KEY ("SENTIMENT_LOOKUP_STATUS_CODE") 
 USING INDEX;
 
------------------------------------------------------------------------------ 
 
/* Create Foreign Key Constraints */

ALTER TABLE  "Sentiment_snapshot" 
 ADD CONSTRAINT "FK_SENTIMENT_SNAPSHOT_SENTIMENT_LOOKUP"
	FOREIGN KEY ("LOOKUP_ID") REFERENCES  "Sentiment_lookup" ("LOOKUP_ID");

ALTER TABLE  "Sentiment_snapshot" 
 ADD CONSTRAINT "FK_SENTIMENT_SNAPSHOT_SENTIMENT_LOOKUP_DOMAIN"
	FOREIGN KEY ("SENTIMENT_LOOKUP_DOMAIN_CODE") 
		REFERENCES  "Sentiment_lookup_domain" ("SENTIMENT_LOOKUP_DOMAIN_CODE");
 ------------

ALTER TABLE  "Sentiment_lookup" 
 ADD CONSTRAINT "FK_SENTIMENT_LOOKUP_SENTIMENT_STATUS_CODE"
	FOREIGN KEY ("SENTIMENT_LOOKUP_STATUS_CODE") 
		REFERENCES  "Sentiment_lookup_status" ("SENTIMENT_LOOKUP_STATUS_CODE");

ALTER TABLE  "Sentiment_lookup" 
 ADD CONSTRAINT "FK_SENTIMENT_LOOKUP_SENTIMENT_TYPE"
	FOREIGN KEY ("SENTIMENT_TYPE_CODE") 
		REFERENCES  "Sentiment_type" ("SENTIMENT_TYPE_CODE");
 -------------

---------------------------------------------------------------------------

/* Create Sequences */

CREATE SEQUENCE sentiment_snapshot_seq
 START WITH     1000
 INCREMENT BY   1
 NOMAXVALUE
 NOCACHE
 NOCYCLE;
 
CREATE SEQUENCE sentiment_type_seq
 START WITH     1000
 INCREMENT BY   1
 NOMAXVALUE
 NOCACHE
 NOCYCLE;
 
CREATE SEQUENCE sentiment_lookup_seq
 START WITH     1000
 INCREMENT BY   1
 NOMAXVALUE
 NOCACHE
 NOCYCLE;
 
CREATE SEQUENCE sentiment_lookup_domain_seq
 START WITH     1000
 INCREMENT BY   1
 NOMAXVALUE
 NOCACHE
 NOCYCLE;
 
CREATE SEQUENCE sentiment_lookup_status_seq
 START WITH     1000
 INCREMENT BY   1
 NOMAXVALUE
 NOCACHE
 NOCYCLE;
		
	
	
	