-- SCRIPT: drop_stats.sql
-- AUTHOR: Your Name
-- PURPOSE: To drop statistics for the music_owner schema.

BEGIN
  DBMS_STATS.DELETE_SCHEMA_STATS(
    ownname => 'MUSIC_OWNER'
  );
END;
/