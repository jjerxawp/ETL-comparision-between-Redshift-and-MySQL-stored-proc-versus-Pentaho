USE asm3_source;

-- SP dim_country

DELIMITER $$
CREATE procedure load_dim_country ()
BEGIN
    INSERT INTO asm3_dim.dim_country (country)
        SELECT DISTINCT asm3_source.netflix_shows.country FROM asm3_source.netflix_shows
        WHERE NOT EXISTS (
            SELECT 1 FROM asm3_dim.dim_country
                     WHERE netflix_shows.country = asm3_dim.dim_country.country
        ) AND asm3_source.netflix_shows.country IS NOT NULL;
END $$
DELIMITER ;

-- SP dim_type

DELIMITER $$
CREATE PROCEDURE load_dim_type ()
BEGIN
   INSERT INTO asm3_dim.dim_type (type)
       SELECT DISTINCT asm3_source.netflix_shows.type FROM asm3_source.netflix_shows
            WHERE NOT EXISTS(
            SELECT 1 FROM asm3_dim.dim_type
                     WHERE asm3_source.netflix_shows.type = asm3_dim.dim_type.type
        ) AND asm3_source.netflix_shows.type IS NOT NULL;
END $$
DELIMITER ;

-- SP dim_info

DELIMITER $$
CREATE PROCEDURE load_dim_info ()
BEGIN
    INSERT INTO asm3_dim.dim_info (title, listed_in, description, cast)
        SELECT
            SUBSTRING_INDEX(full_info,'|',1) AS title,
            SUBSTRING_INDEX(SUBSTRING_INDEX(full_info,'|',2),'|',-1) AS listed_in,
            SUBSTRING_INDEX(SUBSTRING_INDEX(full_info,'|',3),'|',-1) AS description,
            SUBSTRING_INDEX(SUBSTRING_INDEX(full_info,'|',4),'|',-1) AS cast
        FROM
            (SELECT
                DISTINCT CONCAT(asm3_source.netflix_shows.title,
                         '|',
                         asm3_source.netflix_shows.listed_in,
                         '|',
                         asm3_source.netflix_shows.description,
                         '|',
                         asm3_source.netflix_shows.cast) AS full_info
             FROM asm3_source.netflix_shows
             ) AS concat
            WHERE
                1 = 1
            AND NOT EXISTS(
                SELECT 1 FROM asm3_dim.dim_info
                         WHERE
                             concat.full_info
                            = CONCAT(asm3_dim.dim_info.title,
                                  asm3_dim.dim_info.listed_in,
                                  asm3_dim.dim_info.description,
                                  asm3_dim.dim_info.cast)
            )
            AND concat.full_info IS NOT NULL ;
END $$
DELIMITER ;

-- SP dim_duration
DELIMITER $$
CREATE PROCEDURE load_dim_duration()
BEGIN
    INSERT INTO asm3_dim.dim_duration (duration)
        SELECT
            DISTINCT asm3_source.netflix_shows.duration
        FROM
            netflix_shows
            WHERE
                1 = 1
            AND
                NOT EXISTS(
                    SELECT 1 FROM asm3_dim.dim_duration
                             WHERE asm3_dim.dim_duration.duration = asm3_source.netflix_shows.duration
                )
            AND asm3_source.netflix_shows.duration IS NOT NULL ;

    END $$
DELIMITER ;

-- SP for dim_rating

DELIMITER $$
CREATE PROCEDURE load_dim_rating ()
    BEGIN
        INSERT INTO asm3_dim.dim_rating (rating)
            SELECT
                DISTINCT asm3_source.netflix_shows.rating
            FROM
                asm3_source.netflix_shows
                    WHERE
                        1=1
                        AND NOT EXISTS(
                            SELECT 1 FROM asm3_dim.dim_rating
                                     WHERE asm3_source.netflix_shows.rating = asm3_dim.dim_rating.rating
                    )
                        AND asm3_source.netflix_shows.rating IS NOT NULL ;

    END $$
DELIMITER ;


-- SP dim_date

DELIMITER $$
CREATE PROCEDURE load_dim_date()
BEGIN
    INSERT INTO asm3_dim.dim_date (date_added, release_year)
    SELECT
        SUBSTRING_INDEX(full_date, ',', 1) AS date_added,
        SUBSTRING_INDEX(full_date, ',', -1) AS release_year
    FROM (
        SELECT DISTINCT CONCAT(TRIM(asm3_source.netflix_shows.date_added), ',', TRIM(asm3_source.netflix_shows.release_year)) AS full_date
        FROM asm3_source.netflix_shows
        WHERE asm3_source.netflix_shows.date_added IS NOT NULL
    ) AS CTE
    WHERE NOT EXISTS (
        SELECT 1
        FROM asm3_dim.dim_date
        WHERE CONCAT(asm3_dim.dim_date.date_added, ',', asm3_dim.dim_date.release_year) = CTE.full_date
    );
END $$
DELIMITER ;

-- SP dim_director

DELIMITER $$
CREATE PROCEDURE load_dim_director()
    BEGIN
       INSERT INTO asm3_dim.dim_director (director)
           SELECT
               DISTINCT asm3_source.netflix_shows.director
           FROM
               asm3_source.netflix_shows
                WHERE
                    1=1
                    AND NOT EXISTS(
                        SELECT 1 FROM asm3_dim.dim_director
                                 WHERE asm3_source.netflix_shows.director = asm3_dim.dim_director.director
                )
                    AND netflix_shows.director IS NOT NULL ;
    END $$
DELIMITER ;

-- SP for loading fact
DELIMITER $$

CREATE PROCEDURE load_fact_netflix_shows()
BEGIN
    INSERT INTO asm3_dim.fact_netflix_shows (show_id, info_id, type_id, director_id, country_id, date_id, rating_id, duration_id)
    SELECT
        asm3_source.netflix_shows.show_id,
        asm3_dim.dim_info.info_id,
        asm3_dim.dim_type.type_id,
        asm3_dim.dim_director.director_id,
        asm3_dim.dim_country.country_id,
        asm3_dim.dim_date.date_id,
        asm3_dim.dim_rating.rating_id,
        asm3_dim.dim_duration.duration_id
    FROM
        asm3_source.netflix_shows
    LEFT JOIN asm3_dim.dim_info ON (dim_info.cast = asm3_source.netflix_shows.cast
        AND dim_info.description = asm3_source.netflix_shows.description
        AND dim_info.listed_in = asm3_source.netflix_shows.listed_in
        AND dim_info.title = asm3_source.netflix_shows.title)
    LEFT JOIN asm3_dim.dim_type ON dim_type.type = asm3_source.netflix_shows.type
    LEFT JOIN asm3_dim.dim_director ON dim_director.director = asm3_source.netflix_shows.director
    LEFT JOIN asm3_dim.dim_country ON dim_country.country = asm3_source.netflix_shows.country
    LEFT JOIN asm3_dim.dim_date ON dim_date.date_added = asm3_source.netflix_shows.date_added
        AND dim_date.release_year = asm3_source.netflix_shows.release_year
    LEFT JOIN asm3_dim.dim_rating ON dim_rating.rating = asm3_source.netflix_shows.rating
    LEFT JOIN asm3_dim.dim_duration ON dim_duration.duration = asm3_source.netflix_shows.duration
    ON DUPLICATE KEY UPDATE
        info_id = VALUES(info_id),
        type_id = VALUES(type_id),
        director_id = VALUES(director_id),
        country_id = VALUES(country_id),
        date_id = VALUES(date_id),
        rating_id = VALUES(rating_id),
        duration_id = VALUES(duration_id);
END $$
DELIMITER ;

-- SP for loading_all
DELIMITER $$
CREATE PROCEDURE asm3_load_all()
    BEGIN
       CALL load_dim_country();
       CALL load_dim_type();
       CALL load_dim_info();
       CALL load_dim_duration();
       CALL load_dim_rating();
       CALL load_dim_date();
       CALL load_dim_director();
       CALL load_fact_netflix_shows();
    END $$
DELIMITER ;

-- SP for reset all
DELIMITER $$
CREATE PROCEDURE asm3_reset_all()
    BEGIN
       DROP TABLE IF EXISTS asm3_dim.fact_netflix_shows;
       TRUNCATE asm3_dim.dim_info;
       TRUNCATE asm3_dim.dim_duration;
       TRUNCATE asm3_dim.dim_rating;
       TRUNCATE asm3_dim.dim_date;
       TRUNCATE asm3_dim.dim_country;
       TRUNCATE asm3_dim.dim_director;
       TRUNCATE asm3_dim.dim_type;
       create table if not exists asm3_dim.fact_netflix_shows (
            show_id int primary key,
            info_id int,
            type_id int,
            director_id int,
            country_id int,
            date_id int,
            rating_id int,
            duration_id int,
            foreign key (info_id) references asm3_dim.dim_info(info_id),
            foreign key (type_id) references asm3_dim.dim_type(type_id),
            foreign key (director_id) references asm3_dim.dim_director(director_id),
            foreign key (country_id) references asm3_dim.dim_country(country_id),
            foreign key (date_id) references asm3_dim.dim_date(date_id),
            foreign key (rating_id) references asm3_dim.dim_rating(rating_id),
            foreign key (duration_id) references asm3_dim.dim_duration(duration_id)
        );
    END $$
DELIMITER ;


CALL asm3_reset_all();
select * from asm3_dim.fact_netflix_shows; -- Used for quickly restart and debugged only;
CALL asm3_load_all();
select * from asm3_dim.fact_netflix_shows;
