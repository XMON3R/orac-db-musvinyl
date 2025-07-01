
-- AUTHOR: Šimon Jůza
-- PURPOSE: Creates the entire database schema (all objects) from 
--          scratch in the correct dependency order.

SET SERVEROUTPUT ON;

-- -----------------------------------------------------------------
-- Step 1: Create Tables and Sequences
-- -----------------------------------------------------------------
PROMPT -- Step 1: Creating Tables and Sequences...

CREATE SEQUENCE artists_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE artists (
    artist_id NUMBER PRIMARY KEY,
    artist_name VARCHAR2(200) NOT NULL UNIQUE,
    year_founded NUMBER(4),
    is_active CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y', 'N')),
    biography_url VARCHAR2(500)
);

CREATE SEQUENCE members_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE members (
    member_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(200) NOT NULL UNIQUE
);

CREATE TABLE artist_members (
    artist_id NUMBER NOT NULL,
    member_id NUMBER NOT NULL,
    role VARCHAR2(100),
    CONSTRAINT pk_artist_members PRIMARY KEY (artist_id, member_id),
    CONSTRAINT fk_am_artist FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE,
    CONSTRAINT fk_am_member FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE SEQUENCE labels_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE labels (
    label_id NUMBER PRIMARY KEY,
    label_name VARCHAR2(200) NOT NULL UNIQUE,
    founder_artist_id NUMBER,
    CONSTRAINT fk_label_founder FOREIGN KEY (founder_artist_id) REFERENCES artists(artist_id)
);

CREATE SEQUENCE albums_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE albums (
    album_id NUMBER PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    primary_artist_id NUMBER NOT NULL,
    release_year NUMBER(4) NOT NULL,
    producer VARCHAR2(200),
    CONSTRAINT fk_album_artist FOREIGN KEY (primary_artist_id) REFERENCES artists(artist_id)
);

CREATE SEQUENCE releases_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE releases (
    release_id NUMBER PRIMARY KEY,
    album_id NUMBER NOT NULL,
    label_id NUMBER NOT NULL,
    release_date DATE,
    format VARCHAR2(50) NOT NULL,
    catalog_number VARCHAR2(100),
    CONSTRAINT fk_release_album FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE,
    CONSTRAINT fk_release_label FOREIGN KEY (label_id) REFERENCES labels(label_id)
);

CREATE SEQUENCE tracks_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE tracks (
    track_id NUMBER PRIMARY KEY,
    album_id NUMBER NOT NULL,
    title VARCHAR2(200) NOT NULL,
    track_number NUMBER,
    duration_seconds NUMBER,
    CONSTRAINT fk_track_album FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE
);

CREATE TABLE track_features (
    track_id NUMBER NOT NULL,
    guest_artist_id NUMBER NOT NULL,
    CONSTRAINT pk_track_features PRIMARY KEY (track_id, guest_artist_id),
    CONSTRAINT fk_tf_track FOREIGN KEY (track_id) REFERENCES tracks(track_id),
    CONSTRAINT fk_tf_artist FOREIGN KEY (guest_artist_id) REFERENCES artists(artist_id)
);

-- -----------------------------------------------------------------
-- Step 2: Create Indexes
-- -----------------------------------------------------------------
PROMPT -- Step 2: Creating Indexes...

CREATE INDEX idx_am_artist_id ON artist_members(artist_id);
CREATE INDEX idx_am_member_id ON artist_members(member_id);
CREATE INDEX idx_label_founder_id ON labels(founder_artist_id);
CREATE INDEX idx_album_artist_id ON albums(primary_artist_id);
CREATE INDEX idx_release_album_id ON releases(album_id);
CREATE INDEX idx_release_label_id ON releases(label_id);
CREATE INDEX idx_track_album_id ON tracks(album_id);
CREATE INDEX idx_tf_track_id ON track_features(track_id);
CREATE INDEX idx_tf_guest_artist_id ON track_features(guest_artist_id);

-- -----------------------------------------------------------------
-- Step 3: Create Views
-- -----------------------------------------------------------------
PROMPT -- Step 3: Creating Views...

CREATE OR REPLACE VIEW V_ARTIST_DISCOGRAPHY AS
SELECT
    a.artist_name,
    al.title AS album_title,
    al.release_year,
    r.format,
    l.label_name AS release_label,
    r.release_date
FROM artists a
JOIN albums al ON a.artist_id = al.primary_artist_id
JOIN releases r ON al.album_id = r.album_id
JOIN labels l ON r.label_id = l.label_id
ORDER BY a.artist_name, al.release_year, r.release_date;

CREATE OR REPLACE VIEW V_ALBUM_DETAILS AS
SELECT
    al.title AS album_title,
    a.artist_name,
    t.track_number,
    t.title AS track_title,
    t.duration_seconds
FROM albums al
JOIN artists a ON al.primary_artist_id = a.artist_id
JOIN tracks t ON al.album_id = t.album_id
ORDER BY a.artist_name, al.title, t.track_number;

CREATE OR REPLACE VIEW V_ARTIST_COLLABORATIONS AS
SELECT
    guest.artist_name AS guest_artist,
    primary_a.artist_name AS primary_artist,
    al.title AS on_album,
    t.title AS on_track
FROM artists guest
JOIN track_features tf ON guest.artist_id = tf.guest_artist_id
JOIN tracks t ON tf.track_id = t.track_id
JOIN albums al ON t.album_id = al.album_id
JOIN artists primary_a ON al.primary_artist_id = primary_a.artist_id
ORDER BY guest.artist_name, primary_a.artist_name;

-- -----------------------------------------------------------------
-- Step 4: Create Triggers
-- -----------------------------------------------------------------
PROMPT -- Step 4: Creating Triggers...

-- Trigger 1: Prevents setting a founding year that is in the future.
CREATE OR REPLACE TRIGGER trg_validate_artist_year
BEFORE INSERT OR UPDATE OF year_founded ON artists
FOR EACH ROW
BEGIN
    -- Check if the new year is greater than the current year
    IF :NEW.year_founded > EXTRACT(YEAR FROM SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20002, 'The founding year cannot be in the future.');
    END IF;
END;
/

-- Trigger 2: Prevents an album's release year from being before the artist was founded.
CREATE OR REPLACE TRIGGER trg_validate_album_release_year
BEFORE INSERT OR UPDATE ON albums
FOR EACH ROW
DECLARE
    v_artist_founded_year artists.year_founded%TYPE;
BEGIN
    -- Get the founding year of the artist for the new album
    SELECT year_founded
    INTO v_artist_founded_year
    FROM artists
    WHERE artist_id = :NEW.primary_artist_id;

    -- If the album's year is before the artist's founding year, raise an error
    IF :NEW.release_year < v_artist_founded_year THEN
        RAISE_APPLICATION_ERROR(-20003, 'Album release year (' || :NEW.release_year || ') cannot be before the artist was founded (' || v_artist_founded_year || ').');
    END IF;
END;
/

-- -----------------------------------------------------------------
-- Step 5: Create Package Specifications
-- -----------------------------------------------------------------
PROMPT -- Step 5: Creating Package Specifications...

CREATE OR REPLACE PACKAGE artist_pkg AS
    PROCEDURE p_add_artist (pi_artist_name IN artists.artist_name%TYPE, pi_year_founded IN artists.year_founded%TYPE, pi_is_active IN artists.is_active%TYPE DEFAULT 'Y');
    PROCEDURE p_add_member_to_band (pi_artist_name IN artists.artist_name%TYPE, pi_member_full_name IN members.full_name%TYPE, pi_role IN artist_members.role%TYPE);

    PROCEDURE p_delete_artist (pi_artist_name IN artists.artist_name%TYPE);

END artist_pkg;
/

CREATE OR REPLACE PACKAGE album_pkg AS
    PROCEDURE p_add_album (pi_artist_name IN artists.artist_name%TYPE, pi_album_title IN albums.title%TYPE, pi_release_year IN albums.release_year%TYPE, pi_producer IN albums.producer%TYPE DEFAULT NULL);
    PROCEDURE p_add_release_to_album (pi_album_title IN albums.title%TYPE, pi_artist_name IN artists.artist_name%TYPE, pi_label_name IN labels.label_name%TYPE, pi_format IN releases.format%TYPE, pi_release_date IN releases.release_date%TYPE, pi_catalog_num IN releases.catalog_number%TYPE DEFAULT NULL);
END album_pkg;
/

-- -----------------------------------------------------------------
-- Step 6: Create Package Bodies
-- -----------------------------------------------------------------
PROMPT -- Step 6: Creating Package Bodies...

CREATE OR REPLACE PACKAGE BODY artist_pkg AS
    PROCEDURE p_add_artist (pi_artist_name IN artists.artist_name%TYPE, pi_year_founded IN artists.year_founded%TYPE, pi_is_active IN artists.is_active%TYPE DEFAULT 'Y') AS
    BEGIN
        INSERT INTO artists (artist_id, artist_name, year_founded, is_active) VALUES (artists_seq.NEXTVAL, pi_artist_name, pi_year_founded, pi_is_active);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: Artist ' || pi_artist_name || ' added.');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('Error: Artist "' || pi_artist_name || '" already exists.'); ROLLBACK;
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM); ROLLBACK;
    END p_add_artist;

    PROCEDURE p_add_member_to_band (pi_artist_name IN artists.artist_name%TYPE, pi_member_full_name IN members.full_name%TYPE, pi_role IN artist_members.role%TYPE) AS
        v_artist_id artists.artist_id%TYPE;
        v_member_id members.member_id%TYPE;
    BEGIN
        SELECT artist_id INTO v_artist_id FROM artists WHERE artist_name = pi_artist_name;
        SELECT member_id INTO v_member_id FROM members WHERE full_name = pi_member_full_name;
        INSERT INTO artist_members (artist_id, member_id, role) VALUES (v_artist_id, v_member_id, pi_role);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: ' || pi_member_full_name || ' added to ' || pi_artist_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Error: Could not find artist "' || pi_artist_name || '" or member "' || pi_member_full_name || '".'); ROLLBACK;
        WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('Error: ' || pi_member_full_name || ' is already a member of ' || pi_artist_name || '.'); ROLLBACK;
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM); ROLLBACK;
    END p_add_member_to_band;

    -- needed ?
    PROCEDURE p_delete_artist (pi_artist_name IN artists.artist_name%TYPE) AS
        v_artist_id   artists.artist_id%TYPE;
        v_album_count NUMBER;
    BEGIN
        -- Find the artist's ID first
        SELECT artist_id INTO v_artist_id
        FROM artists WHERE artist_name = pi_artist_name;

        -- Check for dependent albums BEFORE trying to delete
        SELECT COUNT(*) INTO v_album_count
        FROM albums WHERE primary_artist_id = v_artist_id;

        IF v_album_count > 0 THEN
            -- If albums exist, now we can raise our custom error
            RAISE_APPLICATION_ERROR(-20001, 'Cannot delete artist: ' || pi_artist_name || ' still has ' || v_album_count || ' album(s) in the database.');
        ELSE
            -- Only if no albums exist, do we delete the artist
            DELETE FROM artists WHERE artist_id = v_artist_id;
            COMMIT;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Artist "' || pi_artist_name || '" not found.');
            ROLLBACK;
        WHEN OTHERS THEN
            -- This will catch our custom RAISE_APPLICATION_ERROR and display it
            ROLLBACK;
            RAISE; -- Re-raise the exception so the client tool sees the error
    END p_delete_artist;

END artist_pkg;
/

CREATE OR REPLACE PACKAGE BODY album_pkg AS
    PROCEDURE p_add_album (pi_artist_name IN artists.artist_name%TYPE, pi_album_title IN albums.title%TYPE, pi_release_year IN albums.release_year%TYPE, pi_producer IN albums.producer%TYPE DEFAULT NULL) AS
        v_artist_id artists.artist_id%TYPE;
    BEGIN
        SELECT artist_id INTO v_artist_id FROM artists WHERE artist_name = pi_artist_name;
        INSERT INTO albums (album_id, title, primary_artist_id, release_year, producer) VALUES (albums_seq.NEXTVAL, pi_album_title, v_artist_id, pi_release_year, pi_producer);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: Album "' || pi_album_title || '" added for artist ' || pi_artist_name || '.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Error: Artist "' || pi_artist_name || '" not found.'); ROLLBACK;
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM); ROLLBACK;
    END p_add_album;

    PROCEDURE p_add_release_to_album (pi_album_title IN albums.title%TYPE, pi_artist_name IN artists.artist_name%TYPE, pi_label_name IN labels.label_name%TYPE, pi_format IN releases.format%TYPE, pi_release_date IN releases.release_date%TYPE, pi_catalog_num IN releases.catalog_number%TYPE DEFAULT NULL) AS
        v_album_id albums.album_id%TYPE;
        v_label_id labels.label_id%TYPE;
    BEGIN
        SELECT al.album_id INTO v_album_id FROM albums al JOIN artists a ON al.primary_artist_id = a.artist_id WHERE al.title = pi_album_title AND a.artist_name = pi_artist_name;
        SELECT label_id INTO v_label_id FROM labels WHERE label_name = pi_label_name;
        INSERT INTO releases (release_id, album_id, label_id, release_date, format, catalog_number) VALUES (releases_seq.NEXTVAL, v_album_id, v_label_id, pi_release_date, pi_format, pi_catalog_num);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: Added ' || pi_format || ' release for album "' || pi_album_title || '".');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Error: Could not find album, artist, or label specified.'); ROLLBACK;
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM); ROLLBACK;
    END p_add_release_to_album;
END album_pkg;
/

PROMPT --== Master Schema Creation Complete ==--
