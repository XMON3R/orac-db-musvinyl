-- AUTHOR: Šimon Jůza
-- PURPOSE: To demonstrate and test all application logic functionality.

-- Enable output to see the messages from our procedures
SET SERVEROUTPUT ON;

-- =================================================================
-- TEST 1: ARTIST MANAGEMENT (artist_pkg)
-- =================================================================
PROMPT -- TEST 1: ARTIST MANAGEMENT --

PROMPT -- Adding a new artist: Pink Floyd...
BEGIN
    artist_pkg.p_add_artist(
        pi_artist_name   => 'Pink Floyd',
        pi_year_founded  => 1965,
        pi_is_active     => 'N'
    );
END;
/

PROMPT -- Verifying Pink Floyd was added...
SELECT * FROM artists WHERE artist_name = 'Pink Floyd';


PROMPT -- TEST (FAILURE): Trying to add the same artist again...
PROMPT -- EXPECTED ERROR: "Artist 'Pink Floyd' already exists."
BEGIN
    artist_pkg.p_add_artist('Pink Floyd', 1965, 'N');
END;
/

-- =================================================================
-- TEST 2: ALBUM MANAGEMENT (album_pkg)
-- =================================================================
PROMPT -- [2a] Adding a new album 'The Dark Side of the Moon' for 'Pink Floyd'...
BEGIN
    album_pkg.p_add_album(
        pi_artist_name  => 'Pink Floyd',
        pi_album_title  => 'The Dark Side of the Moon',
        pi_release_year => 1973,
        pi_producer     => 'Pink Floyd'
    );
END;
/

PROMPT -- [2b] Adding a specific 'LP' release for the new album...
BEGIN
    album_pkg.p_add_release_to_album(
        pi_album_title  => 'The Dark Side of the Moon',
        pi_artist_name  => 'Pink Floyd',
        pi_label_name   => 'Supraphon',
        pi_format       => 'LP',
        pi_release_date => TO_DATE('1978-01-01', 'YYYY-MM-DD')
    );
END;
/

PROMPT -- [2c] NOW verifying the new album and release exist via the view...
SELECT * FROM v_artist_discography WHERE album_title = 'The Dark Side of the Moon';


-- =================================================================
-- TEST 3: TRIGGER FUNCTIONALITY
-- =================================================================
PROMPT -- TEST 3: TRIGGER FUNCTIONALITY --

PROMPT -- TEST (FAILURE): Attempting to delete an artist with albums...
PROMPT -- EXPECTED ERROR: ORA-20001: "Cannot delete artist: The Beatles still has..."

BEGIN
    artist_pkg.p_delete_artist(pi_artist_name => 'The Beatles');
END;
/



-- At the end of test_functionality.sql

PROMPT -- TEST 4: VALIDATE YEAR TRIGGER --
PROMPT -- TEST (FAILURE): Attempting to add an artist with a future year...
PROMPT -- EXPECTED ERROR: ORA-20002: The founding year cannot be in the future.
BEGIN
    artist_pkg.p_add_artist(
        pi_artist_name   => 'The Future Band',
        pi_year_founded  => EXTRACT(YEAR FROM SYSDATE) + 1
    );
END;
/



-- At the end of test_functionality.sql

PROMPT -- TEST 5: VALIDATE ALBUM YEAR TRIGGER --
PROMPT -- TEST (FAILURE): Attempting to add an album with a release year before the artist was founded...
PROMPT -- EXPECTED ERROR: ORA-20003: Album release year (1960) cannot be before...
BEGIN
    album_pkg.p_add_album(
        pi_artist_name  => 'Pink Floyd', -- Founded 1965
        pi_album_title  => 'An impossible Album',
        pi_release_year => 1960
    );
END;
/


PROMPT -- Test complete.
PROMPT -- ////////////////////////////////////////////////
PROMPT -- ////////////////////////////////////////////////
PROMPT -- ////////////////////////////////////////////////
PROMPT -- ////////////////////////////////////////////////
PROMPT -- ////////////////////////////////////////////////



-- See all releases for The Beatles
SELECT * FROM V_ARTIST_DISCOGRAPHY WHERE artist_name = 'The Beatles';

-- See the tracklist for Abbey Road
SELECT * FROM V_ALBUM_DETAILS WHERE album_title = 'Abbey Road';

-- See Ozzy Osbourne's guest appearances
SELECT * FROM V_ARTIST_COLLABORATIONS WHERE guest_artist = 'Ozzy Osbourne';



PROMPT -- Test complete TRULY.
PROMPT -- ////////////////////////////////////////////////
PROMPT -- ////////////////////////////////////////////////
PROMPT -- ////////////////////////////////////////////////
PROMPT -- ////////////////////////////////////////////////
PROMPT -- ////////////////////////////////////////////////
