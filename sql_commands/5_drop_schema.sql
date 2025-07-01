-- SCRIPT: drop_schema.sql
-- AUTHOR: Your Name
-- PURPOSE: To remove all objects from the music database schema.

-- Drop objects in reverse order of creation to avoid dependency errors.

-- Drop Triggers
DROP TRIGGER trg_prevent_artist_deletion;

-- Drop Packages
DROP PACKAGE album_pkg;
DROP PACKAGE artist_pkg;

-- Drop Views
DROP VIEW v_artist_collaborations;
DROP VIEW v_album_details;
DROP VIEW v_artist_discography;

-- Drop Tables (with cascade constraints to handle foreign keys)
DROP TABLE track_features CASCADE CONSTRAINTS;
DROP TABLE tracks CASCADE CONSTRAINTS;
DROP TABLE releases CASCADE CONSTRAINTS;
DROP TABLE albums CASCADE CONSTRAINTS;
DROP TABLE artist_members CASCADE CONSTRAINTS;
DROP TABLE labels CASCADE CONSTRAINTS;
DROP TABLE members CASCADE CONSTRAINTS;
DROP TABLE artists CASCADE CONSTRAINTS;

-- Drop Sequences
DROP SEQUENCE tracks_seq;
DROP SEQUENCE releases_seq;
DROP SEQUENCE albums_seq;
DROP SEQUENCE labels_seq;
DROP SEQUENCE members_seq;
DROP SEQUENCE artists_seq;

-- Purge the recycle bin for a completely clean slate
PURGE RECYCLEBIN;

PROMPT -- Schema has been successfully dropped. --