-- TEST: Show initial state of artists
SELECT * FROM V_ARTIST_DISCOGRAPHY WHERE ARTIST_NAME = 'Led Zeppelin';

-- TEST: Add a new album for an existing artist
BEGIN
    album_pkg.add_album(p_artist_name => 'Led Zeppelin', p_title => 'In Through the Out Door', p_year => 1979, p_producer => 'Jimmy Page');
END;
/

-- TEST (FAILURE): Try to add a duplicate album. Should raise an error.
-- EXPECTED ERROR: ORA-20001: Album already exists for this artist.
BEGIN
    album_pkg.add_album(p_artist_name => 'Led Zeppelin', p_title => 'Led Zeppelin IV', p_year => 1971, p_producer => 'Jimmy Page');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Caught expected error: ' || SQLERRM);
END;
/

-- TEST: Show final state of artists
SELECT * FROM V_ARTIST_DISCOGRAPHY WHERE ARTIST_NAME = 'Led Zeppelin';

