
alter table ALBUMS drop constraint ALBUMSRefsPHOTOS;
alter table PHOTOS drop constraint PHOTOSRefsALBUMS;

DROP TABLE USER_CURRENT_CITY;
DROP TABLE USER_HOMETOWN_CITY;
DROP TABLE EDUCATION;


DROP TABLE PARTICIPANTS;
DROP TABLE USER_EVENTS;
DROP TABLE ALBUMS;
DROP TABLE TAGS;
DROP TABLE PHOTOS;


DROP TABLE MESSAGE;
DROP TABLE PROGRAMS;
DROP TABLE CITIES;
DROP TABLE FRIENDS;


DROP TABLE USERS;



