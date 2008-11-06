USE ivolunteer;

CREATE TABLE LOCATIONS (
    ID VARCHAR(36) NOT NULL,
    STREET VARCHAR(256),
    CITY VARCHAR(256),
    STATE VARCHAR(2),
    ZIP VARCHAR(16),
    LOCATION VARCHAR(512),
    LATITUDE VARCHAR(128),
    LONGITUDE VARCHAR(128),
    PRIMARY KEY (ID)
);

CREATE TABLE EVENTS (
    ID VARCHAR(36) NOT NULL,
    TITLE VARCHAR(256) NOT NULL,
    DESCRIPTION VARCHAR(1024) NOT NULL,
    TIMESTAMP TIMESTAMP NOT NULL,
    DURATION NUMERIC(3),
    CONTACT VARCHAR(256),
    URL VARCHAR(256),
    PHONE VARCHAR(64),
    EMAIL VARCHAR(256),
    SOURCE_ID VARCHAR(36),
    SOURCE_KEY VARCHAR(128),
    SOURCE_URL VARCHAR(256),
    PRIMARY KEY (ID)
);

CREATE TABLE ORGANIZATIONS (
    ID VARCHAR(36) NOT NULL,
    NAME VARCHAR(256) NOT NULL,
    DESCRIPTION VARCHAR(1024),
    PHONE VARCHAR(64),
    EMAIL VARCHAR(512),
    URL VARCHAR(256),
    ORGANIZATION_TYPE_ID VARCHAR(36),
    SOURCE_ID VARCHAR(36),
    SOURCE_KEY VARCHAR(128),
    SOURCE_URL VARCHAR(256),
    PRIMARY KEY (ID)
);

CREATE TABLE ORGANIZATION_TYPES (
    ID VARCHAR(36) NOT NULL,
    NAME VARCHAR(128),
    PRIMARY KEY (ID)
);

ALTER TABLE ORGANIZATIONS ADD CONSTRAINT ORGANIZATION_TYPE_FK FOREIGN KEY (ORGANIZATION_TYPE_ID) REFERENCES ORGANIZATION_TYPES(ID);

CREATE TABLE EVENT_ORGANIZATIONS (
    EVENT_ID VARCHAR(36) NOT NULL,
    ORGANIZATION_ID VARCHAR(36) NOT NULL
);

ALTER TABLE EVENT_ORGANIZATIONS ADD CONSTRAINT EO_ORGANIZATIONS_FK FOREIGN KEY (ORGANIZATION_ID) REFERENCES ORGANIZATIONS(ID);
ALTER TABLE EVENT_ORGANIZATIONS ADD CONSTRAINT EO_EVENTS_FK FOREIGN KEY (EVENT_ID) REFERENCES EVENTS(ID);

CREATE TABLE EVENT_LOCATIONS (
    EVENT_ID VARCHAR(36) NOT NULL,
    LOCATION_ID VARCHAR(36) NOT NULL
);

ALTER TABLE EVENT_LOCATIONS ADD CONSTRAINT EL_EVENT_FK FOREIGN KEY (EVENT_ID) REFERENCES EVENTS(ID);
ALTER TABLE EVENT_LOCATIONS ADD CONSTRAINT EL_LOCATION_FK FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(ID);

CREATE TABLE ORGANIZATION_LOCATIONS (
    ORGANIZATION_ID VARCHAR(36) NOT NULL,
    LOCATION_ID VARCHAR(36) NOT NULL
);

ALTER TABLE ORGANIZATION_LOCATIONS ADD CONSTRAINT OL_ORGANIZATIONS_FK FOREIGN KEY (ORGANIZATION_ID) REFERENCES ORGANIZATIONS(ID);
ALTER TABLE ORGANIZATION_LOCATIONS ADD CONSTRAINT OL_LOCATION_FK FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(ID);

CREATE TABLE INTEREST_AREAS (
    ID VARCHAR(36) NOT NULL,
    NAME VARCHAR(128) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE EVENT_INTEREST_AREAS (
    INTEREST_AREA_ID VARCHAR(36) NOT NULL,
    EVENT_ID VARCHAR(36) NOT NULL
);

ALTER TABLE EVENT_INTEREST_AREAS ADD CONSTRAINT EIA_INTEREST_AREA_FK FOREIGN KEY (INTEREST_AREA_ID) REFERENCES INTEREST_AREAS(ID);
ALTER TABLE EVENT_INTEREST_AREAS ADD CONSTRAINT EIA_EVENTS_FK FOREIGN KEY (EVENT_ID) REFERENCES EVENTS(ID);

CREATE TABLE ORGANIZATION_INTEREST_AREAS (
    INTEREST_AREA_ID VARCHAR(36) NOT NULL,
    ORGANIZATION_ID VARCHAR(36) NOT NULL
);

ALTER TABLE ORGANIZATION_INTEREST_AREAS ADD CONSTRAINT OIA_INTEREST_AREA_FK FOREIGN KEY (INTEREST_AREA_ID) REFERENCES INTEREST_AREAS(ID);
ALTER TABLE ORGANIZATION_INTEREST_AREAS ADD CONSTRAINT OIA_EVENTS_FK FOREIGN KEY (ORGANIZATION_ID) REFERENCES ORGANIZATIONS(ID);

CREATE TABLE SOURCES (
    ID VARCHAR(36) NOT NULL,
    NAME VARCHAR(128),
    ETL_CLASS VARCHAR(128),
    PRIMARY KEY (ID)
);

ALTER TABLE EVENTS ADD CONSTRAINT EVENTS_SOURCE_FK FOREIGN KEY (SOURCE_ID) REFERENCES SOURCES(ID);
ALTER TABLE ORGANIZATIONS ADD CONSTRAINT ORGANIZATION_SOURCE_FK FOREIGN KEY (SOURCE_ID) REFERENCES SOURCES(ID);

CREATE TABLE NETWORKS (
    ID VARCHAR(36) NOT NULL,
    NAME VARCHAR(128) NOT NULL,
    URL VARCHAR(256),
    PRIMARY KEY (ID)
);

CREATE TABLE USERS (
    ID VARCHAR(36) NOT NULL,
    NAME VARCHAR(128) NOT NULL,
    PASSWORD VARCHAR(128) NOT NULL,
    IPHONE_ID VARCHAR(128),
    PRIMARY KEY (ID)
);

CREATE TABLE INTEGRATIONS (
    ID VARCHAR(36) NOT NULL,
    USER_ID VARCHAR(36) NOT NULL,
    NETWORK_ID VARCHAR(36) NOT NULL,
    USER_NAME VARCHAR(128) NOT NULL,
    PASSWORD VARCHAR(128),
    PRIMARY KEY (ID)
);

ALTER TABLE INTEGRATIONS ADD CONSTRAINT USER_INTEG_FK FOREIGN KEY (USER_ID) REFERENCES USERS(ID);
ALTER TABLE INTEGRATIONS ADD CONSTRAINT NETWORK_INTEG_FK FOREIGN KEY (NETWORK_ID) REFERENCES NETWORKS(ID);

CREATE TABLE TIMEFRAMES (
    ID VARCHAR(36) NOT NULL,
    BUCKET NUMERIC(30) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE DISTANCES (
    ID VARCHAR(36) NOT NULL,
    BUCKET NUMERIC(4) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE FILTER (
    ID VARCHAR(36) NOT NULL,
    USER_ID VARCHAR(36) NOT NULL,
    LATITUDE VARCHAR(128),
    LONGITUDE VARCHAR(128),
    TIMEFRAME_ID VARCHAR(36),
    DISTANCE_ID VARCHAR(36),
    PRIMARY KEY (ID)
);

ALTER TABLE FILTER ADD CONSTRAINT FILTER_USER_FK FOREIGN KEY (USER_ID) REFERENCES USERS(ID);
ALTER TABLE FILTER ADD CONSTRAINT FILTER_TIMEFRAME_FK FOREIGN KEY (TIMEFRAME_ID) REFERENCES TIMEFRAMES(ID);
ALTER TABLE FILTER ADD CONSTRAINT FILTER_DISTANCE_FK FOREIGN KEY (DISTANCE_ID) REFERENCES DISTANCES(ID);

CREATE TABLE FILTER_INTEREST_AREAS (
    FILTER_ID VARCHAR(36) NOT NULL,
    INTEREST_AREA_ID VARCHAR(36) NOT NULL
);

ALTER TABLE FILTER_INTEREST_AREAS ADD CONSTRAINT FIA_INTEREST_AREA_FK FOREIGN KEY (INTEREST_AREA_ID) REFERENCES INTEREST_AREAS(ID);
ALTER TABLE FILTER_INTEREST_AREAS ADD CONSTRAINT FIA_FILTER_FK FOREIGN KEY (FILTER_ID) REFERENCES FILTER(ID);

CREATE TABLE FILTER_ORGANIZATION_TYPES (
    FILTER_ID VARCHAR(36) NOT NULL,
    ORGANIZATION_TYPE_ID VARCHAR(36) NOT NULL
);

ALTER TABLE FILTER_ORGANIZATION_TYPES ADD CONSTRAINT FOT_FILTER_FK FOREIGN KEY (FILTER_ID) REFERENCES FILTER(ID);
ALTER TABLE FILTER_ORGANIZATION_TYPES ADD CONSTRAINT FOT_ORGANIZATION_TYPE_FK FOREIGN KEY (ORGANIZATION_TYPE_ID) REFERENCES ORGANIZATION_TYPES(ID);

CREATE TABLE SOURCE_INTEREST_MAP (
    ID VARCHAR(36) NOT NULL,
    SOURCE_ID VARCHAR(36) NOT NULL,
    SOURCE_KEY VARCHAR(128) NOT NULL,
    INTEREST_AREA_ID VARCHAR(36) NOT NULL,
    PRIMARY KEY (ID)
);

ALTER TABLE SOURCE_INTEREST_MAP ADD CONSTRAINT SIM_SOURCE_FK FOREIGN KEY (SOURCE_ID) REFERENCES SOURCES(ID);
ALTER TABLE SOURCE_INTEREST_MAP ADD CONSTRAINT SIM_INTEREST_AREA_FK FOREIGN KEY (INTEREST_AREA_ID) REFERENCES INTEREST_AREAS(ID);

CREATE TABLE SOURCE_ORG_TYPE_MAP (
    ID VARCHAR(36) NOT NULL,
    SOURCE_ID VARCHAR(36) NOT NULL,
    SOURCE_KEY VARCHAR(128) NOT NULL,
    ORGANIZATION_TYPE_ID VARCHAR(36) NOT NULL,
    PRIMARY KEY (ID)
);

ALTER TABLE SOURCE_ORG_TYPE_MAP ADD CONSTRAINT SOTM_SOURCE_FK FOREIGN KEY (SOURCE_ID) REFERENCES SOURCES(ID);
ALTER TABLE SOURCE_ORG_TYPE_MAP ADD CONSTRAINT SOTM_ORG_TYPE_FK FOREIGN KEY (ORGANIZATION_TYPE_ID) REFERENCES ORGANIZATION_TYPES(ID);
