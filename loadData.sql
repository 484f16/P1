create table temp_user as(select * from keykholt.public_user_information);

delete from temp_user
	where user_id in (select user_id from temp_user group by user_id having count(user_id)>1)
	and rowid not in (select min(rowid) from temp_user group by user_id having count(user_id)>1);

insert into users 
	(select user_id,first_name,last_name,year_of_birth,month_of_birth,day_of_birth,gender from TEMP_USER);	




insert into friends
(select * from keykholt.public_are_friends);

 
create sequence city_sequence
	start with 1
	increment by 1;

create or replace trigger city_trigger
	before insert on cities
	for each row
	begin
		select city_sequence.nextval into :new.city_id from dual;
	end;

	
.

run;



create table temp_cities as(
	select distinct hometown_city as city_name,hometown_state as state_name,hometown_country as country_name
	from keykholt.public_user_information
union
	select distinct current_city as city_name,current_state as state_name,current_country as country_name
	from keykholt.public_user_information
union
	select distinct event_city as city_name,event_state as state_name,event_country as country_name
	from keykholt.public_event_information);


insert into cities(city_name,state_name,country_name)
	select distinct city_name,state_name,country_name from temp_cities;



create table temp_albums as (select * from tp);

delete from temp_albums
	where album_id in (select album_id from temp_albums group by album_id having count(album_id)>1)
	and rowid not in (select min(rowid) from temp_albums group by album_id having count(album_id)>1);


SET AUTOCOMMIT OFF

insert into albums
	(select album_id,owner_id,album_name,album_created_time,album_modified_time,album_link,album_visibility,cover_photo_id from temp_albums);

insert into photos
	(select photo_id,album_id,photo_caption,photo_created_time,photo_modified_time,photo_link from tp);

COMMIT
SET AUTOCOMMIT ON





create table temp_events as 
	(select T.event_id,T.event_creator_id,T.event_name,T.event_tagline,T.event_description,T.event_host,T.event_type,T.event_subtype,T.event_location,
		C.city_id, T.event_start_time, T.event_end_time from cities C,keykholt.public_event_information T
		where C.city_name = T.event_city and C.state_name = T.event_state and C.country_name = T.event_country);


delete from temp_events
	where event_id in (select event_id from temp_events group by event_id having count(event_id)>1)
	and rowid not in (select min(rowid) from temp_events group by event_id having count(event_id)>1);

insert into user_events (select * from temp_events);



insert into user_current_city
	(select U.user_id,C.city_id from cities C, temp_user U
	where C.city_name = U.current_city and C.state_name = U.current_state and C.country_name = U.current_country);

insert into user_hometown_city
	(select U.user_id,C.city_id from cities C, temp_user U
	where C.city_name = U.hometown_city and C.state_name = U.hometown_state and C.country_name = U.hometown_country);




create sequence program_sequence
	start with 1
	increment by 1;

create or replace trigger program_trigger
	before insert on programs
	for each row
	begin
		select program_sequence.nextval into :new.program_id from dual;
	end;

	
.

run;



-- create table temp_programs as (select distinct institution_name,program_concentration,program_degree from keykholt.public_user_information);

-- delete from temp_programs
-- 	where institution_name in (select institution_name from temp_programs group by institution_name having count(institution_name)>1)
-- 	and rowid not in (select min(rowid) from temp_programs group by institution_name having count(institution_name)>1);

-- insert into programs(institution,concentration,degree)
-- 	(select institution_name,program_concentration,program_degree from temp_programs);


insert into programs(institution,concentration,degree)
	(select distinct institution_name,program_concentration,program_degree from keykholt.public_user_information);


create table temp_edu as(select distinct user_id,institution_name,program_concentration,program_degree,program_year
	from keykholt.public_user_information);

insert into education (user_id,program_id,program_year)
	(select T.user_id,P.program_id,T.program_year from temp_edu T, programs P
		where T.institution_name = P.institution and T.program_concentration = P.concentration and T.program_degree = P.degree);



-- create table temp_tag as(select distinct photo_id, tag_subject_id from keykholt.public_tag_information);

insert into tags
	(select photo_id,tag_subject_id,tag_created_time,tag_x_coordinate,tag_y_coordinate from keykholt.public_tag_information);




drop table temp_user;
drop table temp_cities;
drop table temp_albums;
drop table temp_events;
drop table temp_edu;



