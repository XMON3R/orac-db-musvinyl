-- AUTHOR: Šimon Jůza
-- PURPOSE: To generate statistics for the music_owner schema.

BEGIN
  DBMS_STATS.GATHER_SCHEMA_STATS(
    ownname => 'MUSIC_OWNER' 
  );
END;
/