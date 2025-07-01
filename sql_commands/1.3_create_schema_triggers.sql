-- SCRIPT: create_schema_triggers.sql
-- AUTHOR: Your Name
-- PURPOSE: To create all database triggers for enforcing complex business rules.

-- This trigger prevents an artist from being deleted if they still have albums.
CREATE OR REPLACE TRIGGER trg_prevent_artist_deletion
-- Fires BEFORE a DELETE statement is run on the ARTISTS table
BEFORE DELETE ON artists
-- The trigger will execute once for each row that is being deleted
FOR EACH ROW
DECLARE
    v_album_count NUMBER;
BEGIN
    -- Check how many albums this artist has
    SELECT COUNT(*)
    INTO v_album_count
    FROM albums
    WHERE primary_artist_id = :OLD.artist_id; -- :OLD refers to the row being deleted

    -- If the artist has one or more albums, block the deletion
    IF v_album_count > 0 THEN
        -- Raise a custom application error.
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete artist: ' || :OLD.artist_name || ' still has ' || v_album_count || ' album(s) in the database.');
    END IF;
END;
/