-- SCRIPT: generate_stats.sql
-- AUTHOR: Your Name
-- PURPOSE: To generate statistics for the music_owner schema.

BEGIN
  DBMS_STATS.GATHER_SCHEMA_STATS(
    ownname => 'MUSIC_OWNER' -- Note: Schema names are typically uppercase in Oracle
  );
END;
/