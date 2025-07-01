-- SCRIPT: create_schema_procedures.sql
-- AUTHOR: Your Name
-- PURPOSE: Creates all PL/SQL packages (application layer) for the music database.
-- This script should be run AFTER create_schema.sql

SET SERVEROUTPUT ON;

----------------------------------
-- Package for Artist Management
----------------------------------

-- 1. Artist Package Specification
CREATE OR REPLACE PACKAGE artist_pkg AS

    PROCEDURE p_add_artist (
        pi_artist_name   IN artists.artist_name%TYPE,
        pi_year_founded  IN artists.year_founded%TYPE,
        pi_is_active     IN artists.is_active%TYPE DEFAULT 'Y'
    );

    PROCEDURE p_add_member_to_band (
        pi_artist_name      IN artists.artist_name%TYPE,
        pi_member_full_name IN members.full_name%TYPE,
        pi_role             IN artist_members.role%TYPE
    );
    
END artist_pkg;
/

-- 2. Artist Package Body
CREATE OR REPLACE PACKAGE BODY artist_pkg AS

    PROCEDURE p_add_artist (
        pi_artist_name   IN artists.artist_name%TYPE,
        pi_year_founded  IN artists.year_founded%TYPE,
        pi_is_active     IN artists.is_active%TYPE DEFAULT 'Y'
    ) AS
    BEGIN
        INSERT INTO artists (artist_id, artist_name, year_founded, is_active)
        VALUES (artists_seq.NEXTVAL, pi_artist_name, pi_year_founded, pi_is_active);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: Artist ' || pi_artist_name || ' added.');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: Artist "' || pi_artist_name || '" already exists.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            ROLLBACK;
    END p_add_artist;

    PROCEDURE p_add_member_to_band (
        pi_artist_name      IN artists.artist_name%TYPE,
        pi_member_full_name IN members.full_name%TYPE,
        pi_role             IN artist_members.role%TYPE
    ) AS
        v_artist_id artists.artist_id%TYPE;
        v_member_id members.member_id%TYPE;
    BEGIN
        SELECT artist_id INTO v_artist_id FROM artists WHERE artist_name = pi_artist_name;
        SELECT member_id INTO v_member_id FROM members WHERE full_name = pi_member_full_name;

        INSERT INTO artist_members (artist_id, member_id, role)
        VALUES (v_artist_id, v_member_id, pi_role);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: ' || pi_member_full_name || ' added to ' || pi_artist_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Could not find artist "' || pi_artist_name || '" or member "' || pi_member_full_name || '".');
            ROLLBACK;
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || pi_member_full_name || ' is already a member of ' || pi_artist_name || '.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            ROLLBACK;
    END p_add_member_to_band;

END artist_pkg;
/

----------------------------------
-- Package for Album Management
----------------------------------

-- 1. Album Package Specification
CREATE OR REPLACE PACKAGE album_pkg AS

    PROCEDURE p_add_album (
        pi_artist_name   IN artists.artist_name%TYPE,
        pi_album_title   IN albums.title%TYPE,
        pi_release_year  IN albums.release_year%TYPE,
        pi_producer      IN albums.producer%TYPE DEFAULT NULL
    );

    PROCEDURE p_add_release_to_album (
        pi_album_title   IN albums.title%TYPE,
        pi_artist_name   IN artists.artist_name%TYPE,
        pi_label_name    IN labels.label_name%TYPE,
        pi_format        IN releases.format%TYPE,
        pi_release_date  IN releases.release_date%TYPE,
        pi_catalog_num   IN releases.catalog_number%TYPE DEFAULT NULL
    );

END album_pkg;
/

-- 2. Album Package Body
CREATE OR REPLACE PACKAGE BODY album_pkg AS

    PROCEDURE p_add_album (
        pi_artist_name   IN artists.artist_name%TYPE,
        pi_album_title   IN albums.title%TYPE,
        pi_release_year  IN albums.release_year%TYPE,
        pi_producer      IN albums.producer%TYPE DEFAULT NULL
    ) AS
        v_artist_id artists.artist_id%TYPE;
    BEGIN
        SELECT artist_id INTO v_artist_id FROM artists WHERE artist_name = pi_artist_name;

        INSERT INTO albums (album_id, title, primary_artist_id, release_year, producer)
        VALUES (albums_seq.NEXTVAL, pi_album_title, v_artist_id, pi_release_year, pi_producer);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: Album "' || pi_album_title || '" added for artist ' || pi_artist_name || '.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Artist "' || pi_artist_name || '" not found.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            ROLLBACK;
    END p_add_album;

    PROCEDURE p_add_release_to_album (
        pi_album_title   IN albums.title%TYPE,
        pi_artist_name   IN artists.artist_name%TYPE,
        pi_label_name    IN labels.label_name%TYPE,
        pi_format        IN releases.format%TYPE,
        pi_release_date  IN releases.release_date%TYPE,
        pi_catalog_num   IN releases.catalog_number%TYPE DEFAULT NULL
    ) AS
        v_album_id albums.album_id%TYPE;
        v_label_id labels.label_id%TYPE;
    BEGIN
        -- Find the album_id using both title and artist to be specific
        SELECT al.album_id INTO v_album_id 
        FROM albums al JOIN artists a ON al.primary_artist_id = a.artist_id
        WHERE al.title = pi_album_title AND a.artist_name = pi_artist_name;

        -- Find the label_id
        SELECT label_id INTO v_label_id FROM labels WHERE label_name = pi_label_name;

        INSERT INTO releases (release_id, album_id, label_id, release_date, format, catalog_number)
        VALUES (releases_seq.NEXTVAL, v_album_id, v_label_id, pi_release_date, pi_format, pi_catalog_num);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: Added ' || pi_format || ' release for album "' || pi_album_title || '".');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Could not find album, artist, or label specified.');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            ROLLBACK;
    END p_add_release_to_album;

END album_pkg;
/