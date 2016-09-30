# Overview

create table

drop table totally

load data

create view

# Create table

#### not null

$\rightarrow$ bold arrow: need to set not null.

#### mutual constraints

```

ALTER TABLE ALBUMS ADD CONSTRAINT ALBUMSREFSPHOTOS FOREIGN KEY (COVER_PHOTO_ID) REFERENCES PHOTOS INITIALLY DEFERRED DEFERRABLE;

ALTER TABLE PHOTOS ADD CONSTRAINT PHOTOSREFSALBUMS FOREIGN KEY (ALBUM_ID) REFERENCES ALBUMS INITIALLY DEFERRED DEFERRABLE;

```

#### Deduplication

- this can be done in the loadData part:

```

delete from temp_user

where user_id in (select user_id from temp_user group by user_id having count(user_id)>1)

and rowid not in (select min(rowid) from temp_user group by user_id having count(user_id)>1);

```

- and use trigger:

```

create trigger friends trigger

before insert on friends

for each row

when (new.user1_ID > new.user2_ID)

declare

    x number;

begin

    x:=:new.user1_id;

    :new.user1_id:=new.user2_id;

    :new.user2_id:=z;

end;

.

/

// use run; when in load part

```

#### Primary key

```

create Table    USER_CURRENT_CITY

     (

        USER_ID  VARCHAR2 (100) REFERENCES USERS(USER_ID) NOT NULL,

        CURRENT_CITY_ID  INTEGER REFERENCES CITIES(CITY_ID),

        PRIMARY KEY (USER_ID,CURRENT_CITY_ID)

     );    

```

You cannot set each attribute named id be primary key, It depends.

# loadData

#### join and union

join: combine column

union: combine rows

#### trigger

```

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

```

#### 

#### is null

to identify if one value is null, cannot use ='' or =null;

should be: is null

# drop table

```

alter table ALBUMS drop constraint ALBUMSRefsPHOTOS;

alter table PHOTOS drop constraint PHOTOSRefsALBUMS;

```

# create Views

#### as 

1. as new_name 

to make sure each column is diff from each other

2. as new_type

to make sure type to type

```

cast(u.user_id as varchar2(100))

```

#### join

```

CREATE VIEW VIEW_USER_INFORMATION AS 

SELECT U.USER_ID,U.FIRST_NAME,U.LAST_NAME,U.YEAR_OF_BIRTH,U.MONTH_OF_BIRTH,U.DAY_OF_BIRTH,U.GENDER,

C1.CITY_NAME AS CURRENT_CITY,C1.STATE_NAME AS CURRENT_STATE,C1.COUNTRY_NAME AS CURRENT_COUNTRY,

C2.CITY_NAME AS HOMETOWN_CITY,C2.STATE_NAME AS HOMETOWN_STATE,C2.COUNTRY_NAME AS HOMETOWN_COUNTRY,

P.INSTITUTION AS INSTITUTION_NAME,E.PROGRAM_YEAR,P.CONCENTRATION AS PROGRAM_CONCENTRATION,

P.DEGREE AS RPOGRAM_DEGREE

FROM USERS U 

INNER JOIN USER_CURRENT_CITY UC ON UC.USER_ID=U.USER_ID

INNER JOIN CITIES C1 ON UC.CURRENT_CITY_ID=C1.CITY_ID

INNER JOIN USER_HOMETOWN_CITY UH ON U.USER_ID=UH.USER_ID

INNER JOIN CITIES C2  ON UH.HOMETOWN_CITY_ID=C2.CITY_ID

INNER JOIN EDUCATION E ON E.USER_ID=U.USER_ID 

INNER JOIN PROGRAMS P ON P.PROGRAM_ID=E.PROGRAM_ID;

```

# summary

- about null programs information

some students have null programs for their education. After load data to diff tables, these information would be lost.

2 ways to solve:

1.(recommend): set not null for each attribute, and these users with null education information can be rebuilt through left join.

2. set a null row with id for null program, and give all users with no program this tag. so the number of education should be same as the public_user_information.

- ER first

which is important, and set every constraints for sure. some id may not be primary key.

- about deduplication

2 ways:

1. add trigger

2. rowid



