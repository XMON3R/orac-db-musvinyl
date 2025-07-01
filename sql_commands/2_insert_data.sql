-- SCRIPT: insert_data.sql
-- AUTHOR: Your Name
-- PURPOSE: To populate the music database with demonstration data.

-- Turn on server output to see feedback messages (optional)
SET SERVEROUTPUT ON;

BEGIN

    -- == ARTISTS AND MEMBERS ==
    -- Insert bands and solo artists
    INSERT INTO artists (artist_id, artist_name, year_founded, is_active) VALUES (artists_seq.NEXTVAL, 'The Beatles', 1960, 'N');
    INSERT INTO artists (artist_id, artist_name, year_founded, is_active) VALUES (artists_seq.NEXTVAL, 'Led Zeppelin', 1968, 'N');
    INSERT INTO artists (artist_id, artist_name, year_founded, is_active) VALUES (artists_seq.NEXTVAL, 'Black Sabbath', 1968, 'N');
    INSERT INTO artists (artist_id, artist_name, year_founded, is_active) VALUES (artists_seq.NEXTVAL, 'Post Malone', 2013, 'Y');
    INSERT INTO artists (artist_id, artist_name, year_founded, is_active) VALUES (artists_seq.NEXTVAL, 'Ozzy Osbourne', 1979, 'Y'); -- As a solo artist
    DBMS_OUTPUT.PUT_LINE('Artists inserted.');

    -- Insert individual members
    INSERT INTO members (member_id, full_name) VALUES (members_seq.NEXTVAL, 'John Lennon');
    INSERT INTO members (member_id, full_name) VALUES (members_seq.NEXTVAL, 'Paul McCartney');
    INSERT INTO members (member_id, full_name) VALUES (members_seq.NEXTVAL, 'Jimmy Page');
    INSERT INTO members (member_id, full_name) VALUES (members_seq.NEXTVAL, 'Ozzy Osbourne'); -- As a person/member
    DBMS_OUTPUT.PUT_LINE('Members inserted.');

    -- Link members to bands
    INSERT INTO artist_members (artist_id, member_id, role) VALUES ((SELECT artist_id FROM artists WHERE artist_name = 'The Beatles'), (SELECT member_id FROM members WHERE full_name = 'John Lennon'), 'Vocals, Rhythm Guitar');
    INSERT INTO artist_members (artist_id, member_id, role) VALUES ((SELECT artist_id FROM artists WHERE artist_name = 'The Beatles'), (SELECT member_id FROM members WHERE full_name = 'Paul McCartney'), 'Vocals, Bass');
    INSERT INTO artist_members (artist_id, member_id, role) VALUES ((SELECT artist_id FROM artists WHERE artist_name = 'Led Zeppelin'), (SELECT member_id FROM members WHERE full_name = 'Jimmy Page'), 'Lead Guitar');
    INSERT INTO artist_members (artist_id, member_id, role) VALUES ((SELECT artist_id FROM artists WHERE artist_name = 'Black Sabbath'), (SELECT member_id FROM members WHERE full_name = 'Ozzy Osbourne'), 'Lead Vocals');
    DBMS_OUTPUT.PUT_LINE('Artist-Member links created.');

    -- == LABELS ==
    INSERT INTO labels (label_id, label_name) VALUES (labels_seq.NEXTVAL, 'Apple Records');
    INSERT INTO labels (label_id, label_name) VALUES (labels_seq.NEXTVAL, 'Supraphon');
    INSERT INTO labels (label_id, label_name) VALUES (labels_seq.NEXTVAL, 'Republic Records');
    -- A label founded by an artist
    INSERT INTO labels (label_id, label_name, founder_artist_id) VALUES (labels_seq.NEXTVAL, 'Swan Song Records', (SELECT artist_id FROM artists WHERE artist_name = 'Led Zeppelin'));
    DBMS_OUTPUT.PUT_LINE('Labels inserted.');

    -- == The Beatles - Abbey Road ==
    INSERT INTO albums (album_id, title, primary_artist_id, release_year, producer) VALUES (albums_seq.NEXTVAL, 'Abbey Road', (SELECT artist_id FROM artists WHERE artist_name = 'The Beatles'), 1969, 'George Martin');
    -- Add multiple releases for the album
    INSERT INTO releases (release_id, album_id, label_id, release_date, format, catalog_number) VALUES (releases_seq.NEXTVAL, (SELECT album_id FROM albums WHERE title = 'Abbey Road'), (SELECT label_id FROM labels WHERE label_name = 'Apple Records'), TO_DATE('1969-09-26', 'YYYY-MM-DD'), 'LP', 'PCS 7088');
    INSERT INTO releases (release_id, album_id, label_id, release_date, format, catalog_number) VALUES (releases_seq.NEXTVAL, (SELECT album_id FROM albums WHERE title = 'Abbey Road'), (SELECT label_id FROM labels WHERE label_name = 'Supraphon'), TO_DATE('1972-01-01', 'YYYY-MM-DD'), 'LP', '1113 1256');
    -- Add tracks to the album
    INSERT INTO tracks (track_id, album_id, title, track_number) VALUES (tracks_seq.NEXTVAL, (SELECT album_id FROM albums WHERE title = 'Abbey Road'), 'Come Together', 1);
    INSERT INTO tracks (track_id, album_id, title, track_number) VALUES (tracks_seq.NEXTVAL, (SELECT album_id FROM albums WHERE title = 'Abbey Road'), 'Something', 2);
    DBMS_OUTPUT.PUT_LINE('Abbey Road album and releases inserted.');


    -- == Post Malone feat. Ozzy Osbourne ==
    INSERT INTO albums (album_id, title, primary_artist_id, release_year, producer) VALUES (albums_seq.NEXTVAL, 'Hollywood''s Bleeding', (SELECT artist_id FROM artists WHERE artist_name = 'Post Malone'), 2019, 'Louis Bell, Post Malone');
    INSERT INTO releases (release_id, album_id, label_id, release_date, format, catalog_number) VALUES (releases_seq.NEXTVAL, (SELECT album_id FROM albums WHERE title = 'Hollywood''s Bleeding'), (SELECT label_id FROM labels WHERE label_name = 'Republic Records'), TO_DATE('2019-09-06', 'YYYY-MM-DD'), 'Digital', 'N/A');
    INSERT INTO tracks (track_id, album_id, title, track_number) VALUES (tracks_seq.NEXTVAL, (SELECT album_id FROM albums WHERE title = 'Hollywood''s Bleeding'), 'Take What You Want', 11);
    -- Add the "feat." link
    INSERT INTO track_features (track_id, guest_artist_id) VALUES ((SELECT track_id FROM tracks WHERE title = 'Take What You Want'), (SELECT artist_id FROM artists WHERE artist_name = 'Ozzy Osbourne'));
    DBMS_OUTPUT.PUT_LINE('Hollywood''s Bleeding album and feature track inserted.');

    -- Commit the transaction to save all changes
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Data insertion complete and committed.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/


