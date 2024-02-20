create database if not exists asm3_source;

use asm3_source;

create table netflix_shows
(
    show_id      int  null,
    type         text null,
    title        text null,
    director     text null,
    cast         text null,
    country      text null,
    date_added   text null,
    release_year int  null,
    rating       text null,
    duration     text null,
    listed_in    text null,
    description  text null
);

-- -- 
create database if not exists asm3_dim;

use asm3_dim;

create table if not exists dim_country (
    country_id int primary key auto_increment,
    country NVARCHAR(255)
);

create table if not exists dim_director (
    director_id int primary key auto_increment,
    director NVARCHAR(255)
);

create table if not exists dim_type (
    type_id int primary key auto_increment,
    type NVARCHAR(255)
);

create table if not exists dim_info (
    info_id int primary key auto_increment,
    title NVARCHAR(255),
    listed_in NVARCHAR(255),
    description NVARCHAR(1000),
    cast NVARCHAR(2000)
);

create table if not exists dim_duration (
    duration_id int primary key auto_increment,
    duration NVARCHAR(255)
);

create table if not exists dim_rating (
    rating_id int primary key auto_increment,
    rating NVARCHAR(255)
);

create table if not exists dim_date (
    date_id int primary key auto_increment,
    date_added NVARCHAR(255),
    release_year NVARCHAR(255)
);

create table if not exists fact_netflix_shows (
    show_id int primary key,
    info_id int,
    type_id int,
    director_id int,
    country_id int,
    date_id int,
    rating_id int,
    duration_id int,
    foreign key (info_id) references dim_info(info_id),
    foreign key (type_id) references dim_type(type_id),
    foreign key (director_id) references dim_director(director_id),
    foreign key (country_id) references dim_country(country_id),
    foreign key (date_id) references dim_date(date_id),
    foreign key (rating_id) references dim_rating(rating_id),
    foreign key (duration_id) references dim_duration(duration_id)
);