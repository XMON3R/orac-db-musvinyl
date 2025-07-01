-- SCRIPT PART: View Creation
-- PURPOSE: To create virtual tables that simulate application screens and simplify data retrieval.


-- A view to show the complete discography for every artist, including all releases.
CREATE OR REPLACE VIEW V_ARTIST_DISCOGRAPHY AS
SELECT
    a.artist_name,
    al.title AS album_title,
    al.release_year,
    r.format,
    l.label_name AS release_label,
    r.release_date
FROM
    artists a
JOIN
    albums al ON a.artist_id = al.primary_artist_id
JOIN
    releases r ON al.album_id = r.album_id
JOIN
    labels l ON r.label_id = l.label_id
ORDER BY
    a.artist_name, al.release_year, r.release_date;


-- A view to show the details of an album, including its tracklist.
CREATE OR REPLACE VIEW V_ALBUM_DETAILS AS
SELECT
    al.title AS album_title,
    a.artist_name,
    t.track_number,
    t.title AS track_title,
    t.duration_seconds
FROM
    albums al
JOIN
    artists a ON al.primary_artist_id = a.artist_id
JOIN
    tracks t ON al.album_id = t.album_id
ORDER BY
    a.artist_name, al.title, t.track_number;


-- A view specifically to show all guest appearances ("feats").
CREATE OR REPLACE VIEW V_ARTIST_COLLABORATIONS AS
SELECT
    guest.artist_name AS guest_artist,
    primary_a.artist_name AS primary_artist,
    al.title AS on_album,
    t.title AS on_track
FROM
    artists guest
JOIN
    track_features tf ON guest.artist_id = tf.guest_artist_id
JOIN
    tracks t ON tf.track_id = t.track_id
JOIN
    albums al ON t.album_id = al.album_id
JOIN
    artists primary_a ON al.primary_artist_id = primary_a.artist_id
ORDER BY
    guest.artist_name, primary_a.artist_name;
