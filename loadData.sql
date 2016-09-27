create table PUBLIC_USER_INFORMATION AS (SELECT * FROM keykholt.PUBLIC_USER_INFORMATION);




-- TABLE USER
DELETE FROM PUBLIC_USER_INFORMATION
WHERE USER_ID IN (SELECT USER_ID FROM PUBLIC_USER_INFORMATION GROUP BY USER_ID HAVING COUNT(USER_ID)>1)
AND ROWID NOT IN (SELECT MIN(ROWID) FROM PUBLIC_USER_INFORMATION GROUP BY USER_ID HAVING COUNT(USER_ID)>1);


INSERT INTO USERS(SELECT USER_ID,FIRST_NAME,LAST_NAME,YEAR_OF_BIRTH,MONTH_OF_BIRTH,DAY_OF_BIRTH,GENDER FROM PUBLIC_USER_INFORMATION);


-- TABLE FRIENDS
create table AF AS(SELECT T1.USER1_ID, T1.USER2_ID FROM KEYKHOLT.PUBLIC_ARE_FRIENDS T1, KEYKHOLT.PUBLIC_ARE_FRIENDS T2 WHERE T1.USER1_ID=T2.USER2_ID AND T1.USER2_ID=T2.USER1_ID AND T1.USER1_ID>T1.USER2_ID);


INSERT INTO FRIENDS(SELECT USER1_ID, USER2_ID FROM KEYKHOLT.PUBLIC_ARE_FRIENDS MINUS SELECT USER1_ID, USER2_ID FROM AF);


-- TABLE CITIES
create sequence CITIES_SEQ
START WITH 1
INCREMENT BY 1;


CREATE TRIGGER CITIES_TRI
BEFORE INSERT ON CITIES
FOR EACH ROW
BEGIN
SELECT CITIES_SEQ.NEXTVAL INTO :NEW.CITY_ID FROM DUAL;
END;
.
RUN;


INSERT INTO CITIES (CITY_NAME, STATE_NAME, COUNTRY_NAME)
SELECT DISTINCT HOMETOWN_CITY, HOMETOWN_STATE, HOMETOWN_COUNTRY FROM KEYKHOLT.PUBLIC_USER_INFORMATION
UNION
SELECT DISTINCT CURRENT_CITY, CURRENT_STATE, CURRENT_COUNTRY FROM KEYKHOLT.PUBLIC_USER_INFORMATION
UNION
SELECT DISTINCT EVENT_CITY, EVENT_STATE, EVENT_COUNTRY FROM KEYKHOLT.PUBLIC_EVENT_INFORMATION;


-- USER CURRENT CITIES
INSERT INTO USER_CURRENT_CITY(USER_ID,CURRENT_CITY_ID)
SELECT PUI.USER_ID, C.CITY_ID FROM PUBLIC_USER_INFORMATION PUI JOIN CITIES C ON (PUI.CURRENT_CITY=C.CITY_NAME AND PUI.CURRENT_STATE=C.STATE_NAME AND PUI.CURRENT_COUNTRY=C.COUNTRY_NAME);


-- USER HOMETOWN CITIES
INSERT INTO USER_HOMETOWN_CITY(USER_ID,HOMETOWN_CITY_ID)
SELECT PUI.USER_ID, C.CITY_ID FROM PUBLIC_USER_INFORMATION PUI JOIN CITIES C ON (PUI.HOMETOWN_CITY=C.CITY_NAME AND PUI.HOMETOWN_STATE=C.STATE_NAME AND PUI.HOMETOWN_COUNTRY=C.COUNTRY_NAME);


-- MESSAGE




-- PROGRAMS
create sequence PROGRAM_SEQ
START WITH 1
INCREMENT BY 1;


CREATE TRIGGER PROGRAM_TRI
BEFORE INSERT ON PROGRAMS
FOR EACH ROW
BEGIN
SELECT PROGRAM_SEQ.NEXTVAL INTO :NEW.PROGRAM_ID FROM DUAL;
END;
.
RUN;


INSERT INTO PROGRAMS(INSTITUTION, CONCENTRATION,DEGREE)
SELECT DISTINCT INSTITUTION_NAME, PROGRAM_CONCENTRATION, PROGRAM_DEGREE FROM keykholt.PUBLIC_USER_INFORMATION;

--INSERT INTO PROGRAMS(INSTITUTION,CONCENTRATION,DEGREE) VALUES (NULL,NULL,NULL);


-- EDUCATION
INSERT INTO EDUCATION(USER_ID,PROGRAM_ID,PROGRAM_YEAR)
SELECT PUI.USER_ID, P.PROGRAM_ID, PUI.PROGRAM_YEAR
FROM keykholt.PUBLIC_USER_INFORMATION PUI
JOIN PROGRAMS P ON (PUI.INSTITUTION_NAME=P.INSTITUTION
AND PUI.PROGRAM_CONCENTRATION=P.CONCENTRATION AND PUI.PROGRAM_DEGREE=P.DEGREE);

INSERT INTO EDUCATION(USER_ID,PROGRAM_ID,PROGRAM_YEAR)
	SELECT DISTINCT PUI.USER_ID, P.PROGRAM_ID, NULL
	FROM keykholt.PUBLIC_USER_INFORMATION PUI 
	JOIN PROGRAMS P ON (PUI.INSTITUTION_NAME IS NULL 
		AND PUI.PROGRAM_CONCENTRATION IS NULL AND PUI.PROGRAM_DEGREE IS NULL
		AND P.INSTITUTION IS NULL AND P.CONCENTRATION IS NULL AND P.DEGREE IS NULL);



-- USER_EVENTS??????????
INSERT INTO USER_EVENTS (EVENT_ID,EVENT_CREATOR_ID,EVENT_NAME,EVENT_TAGLINE,EVENT_DESCRIPTION,EVENT_HOST,EVENT_TYPE,EVENT_SUBTYPE,EVENT_LOCATION,EVENT_CITY_ID,EVENT_START_TIME,EVENT_END_TIME)
SELECT DISTINCT PEI.EVENT_ID,PEI.EVENT_CREATOR_ID,PEI.EVENT_NAME,PEI.EVENT_TAGLINE,PEI.EVENT_DESCRIPTION,PEI.EVENT_HOST,PEI.EVENT_TYPE,PEI.EVENT_SUBTYPE,PEI.EVENT_LOCATION,C.CITY_ID,PEI.EVENT_START_TIME,PEI.EVENT_END_TIME FROM keykholt.PUBLIC_EVENT_INFORMATION PEI join CITIES C on (PEI.EVENT_CITY=C.CITY_NAME AND PEI.EVENT_STATE=C.STATE_NAME AND PEI.EVENT_COUNTRY=C.COUNTRY_NAME);




-- PARTICIPANTS



-- PHOTOS
INSERT INTO PHOTOS(PHOTO_ID,ALBUM_ID,PHOTO_CAPTION,PHOTO_CREATED_TIME,PHOTO_MODIFIED_TIME,PHOTO_LINK)
SELECT DISTINCT PHOTO_ID,ALBUM_ID,PHOTO_CAPTION,PHOTO_CREATED_TIME,PHOTO_MODIFIED_TIME,PHOTO_LINK FROM keykholt.PUBLIC_PHOTO_INFORMATION;


-- ALBUMS ALBUM_VISIBILITY
INSERT INTO ALBUMS(ALBUM_ID,ALBUM_OWNER_ID,ALBUM_NAME,ALBUM_CREATED_TIME,ALBUM_MODIFIED_TIME,ALBUM_LINK,ALBUM_VISIBILITY,COVER_PHOTO_ID)
SELECT DISTINCT ALBUM_ID,OWNER_ID,ALBUM_NAME,ALBUM_CREATED_TIME,ALBUM_MODIFIED_TIME,ALBUM_LINK,ALBUM_VISIBILITY,COVER_PHOTO_ID FROM keykholt.PUBLIC_PHOTO_INFORMATION;


-- TAGS
INSERT INTO TAGS(TAG_PHOTO_ID,TAG_SUBJECT_ID,TAG_CREATED_TIME,TAG_X,TAG_Y)
SELECT DISTINCT PHOTO_ID,TAG_SUBJECT_ID,TAG_CREATED_TIME,TAG_X_COORDINATE,TAG_Y_COORDINATE FROM keykholt.PUBLIC_TAG_INFORMATION;








DROP TABLE AF;
DROP TABLE PUBLIC_USER_INFORMATION;




DROP sequence CITIES_SEQ;
DROP TRIGGER CITIES_TRI;
DROP sequence PROGRAM_SEQ;
DROP TRIGGER PROGRAM_TRI;
























