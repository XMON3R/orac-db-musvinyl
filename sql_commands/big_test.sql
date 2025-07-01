-- SCRIPT: test_functionality.sql
-- AUTHOR: Your Name
-- PURPOSE: To provide a comprehensive demonstration of all application logic.

-- Enable server output to see feedback messages from the packages
SET SERVEROUTPUT ON;

PROMPT =================================================================
PROMPT == Starting Full Functionality Test ==
PROMPT =================================================================

-- -----------------------------------------------------------------
-- Section 1: Testing artist_pkg
-- -----------------------------------------------------------------
PROMPT
PROMPT -- Section 1: Testing artist_pkg --
PROMPT

PROMPT -- [1a] Adding a new artist: 'Queen'...
BEGIN
    artist_pkg.p_add_artist(
        pi_artist_name   => 'Queen',
        pi_year_founded  => 1970,
        pi_is_active     => 'N'
    );
END;
/

PROMPT -- [1b] Verifying 'Queen' was added by querying the ARTISTS table...
SELECT artist_name, year_founded, is_active FROM artists WHERE artist_name = 'Queen';

PROMPT -- [1c] TEST (FAILURE): Attempting to add a duplicate artist 'Queen'...
PROMPT -- EXPECTED ERROR: "Artist 'Queen' already exists."
BEGIN
    artist_pkg.p_add_artist(pi_artist_name => 'Queen', pi_year_founded => 1970);
END;
/

PROMPT -- [1d] Adding a new member 'Freddie Mercury' to the MEMBERS table...
INSERT INTO members (member_id, full_name) VALUES (members_seq.NEXTVAL, 'Freddie Mercury');
COMMIT;

PROMPT -- [1e] Associating member 'Freddie Mercury' with band 'Queen'...
BEGIN
    artist_pkg.p_add_member_to_band(
        pi_artist_name      => 'Queen',
        pi_member_full_name => 'Freddie Mercury',
        pi_role             => 'Lead Vocals'
    );
END;
/

-- -----------------------------------------------------------------
-- Section 2: Testing album_pkg
-- -----------------------------------------------------------------
PROMPT
PROMPT -- Section 2: Testing album_pkg --
PROMPT

PROMPT -- [2a] Adding a new album 'A Night at the Opera' for 'Queen'...
BEGIN
    album_pkg.p_add_album(
        pi_artist_name  => 'Queen',
        pi_album_title  => 'A Night at the Opera',
        pi_release_year => 1975,
        pi_producer     => 'Roy Thomas Baker, Queen'
    );
END;
/

PROMPT -- [2b] Verifying the new album using the V_ARTIST_DISCOGRAPHY view...
-- Note: This view will be empty for this album until we add a release.
SELECT * FROM v_artist_discography WHERE artist_name = 'Queen';

PROMPT -- [2c] Adding a specific 'LP' release for 'A Night at the Opera'...
BEGIN
    album_pkg.p_add_release_to_album(
        pi_album_title  => 'A Night at the Opera',
        pi_artist_name  => 'Queen',
        pi_label_name   => 'Supraphon', -- Assuming this label exists from initial data
        pi_format       => 'LP',
        pi_release_date => TO_DATE('1976-01-01', 'YYYY-MM-DD')
    );
END;
/

PROMPT -- [2d] Verifying the new release now appears in the V_ARTIST_DISCOGRAPHY view...
SELECT * FROM v_artist_discography WHERE artist_name = 'Queen';


PROMPT -- [2e] TEST (FAILURE): Adding an album for a non-existent artist...
PROMPT -- EXPECTED ERROR: "Artist 'Non-Existent Band' not found."
BEGIN
    album_pkg.p_add_album(
        pi_artist_name  => 'Non-Existent Band',
        pi_album_title  => 'Imaginary Album',
        pi_release_year => 2025
    );
END;
/

-- -----------------------------------------------------------------
-- Section 3: Testing Trigger and Views
-- -----------------------------------------------------------------
PROMPT
PROMPT -- Section 3: Testing Trigger and Views --
PROMPT

PROMPT -- [3a] TEST (FAILURE): Attempting to delete 'The Beatles', who have albums...
PROMPT -- EXPECTED ERROR: ORA-20001: "Cannot delete artist: The Beatles..."
DELETE FROM artists WHERE artist_name = 'The Beatles';

PROMPT
PROMPT -- [3b] Final check on the V_ARTIST_COLLABORATIONS view to show "feat" works...
SELECT * FROM v_artist_collaborations WHERE guest_artist = 'Ozzy Osbourne';

PROMPT
PROMPT =================================================================
PROMPT == Test Script Finished ==
PROMPT =================================================================