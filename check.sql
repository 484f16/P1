SELECT * FROM keykholt.PUBLIC_USER_INFORMATION
MINUS
SELECT * FROM VIEW_USER_INFORMATION;


SELECT * FROM keykholt.PUBLIC_ARE_FRIENDS
MINUS
SELECT * FROM VIEW_ARE_FRIENDS;

SELECT * FROM VIEW_ARE_FRIENDS
MINUS
SELECT * FROM keykholt.PUBLIC_ARE_FRIENDS;


SELECT * FROM keykholt.PUBLIC_ARE_FRIENDS
MINUS
SELECT * FROM VIEW_ARE_FRIENDS


SELECT * FROM keykholt.public_event_information
minus
select * from view_event_information;

select * from view_event_information
minus
select * from keykholt.public_event_information;

select * from keykholt.PUBLIC_PHOTO_INFORMATION
minus 
select * from view_photo_information;

select * from view_photo_information
minus
select * from keykholt.PUBLIC_PHOTO_INFORMATION;

select * from keykholt.PUBLIC_TAG_INFORMATION
minus
select * from VIEW_TAG_INFORMATION;

select * from VIEW_TAG_INFORMATION
minus
select * from keykholt.PUBLIC_TAG_INFORMATION;

