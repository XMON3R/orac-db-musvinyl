## FOR EXPORT
docker exec -it musvinyl expdp music_owner/YourAppPassword@localhost:1521/music_pdb \
DIRECTORY=DATA_PUMP_DIR \
DUMPFILE=music_schema.dmp \
LOGFILE=music_export.log \
SCHEMAS=music_owner


THEN:
docker cp musvinyl:/opt/oracle/oradata/38E2896B62CD0534E063020011ACB54B/music_schema.dmp .

!!!!!!!! EDIT according to use your hex (e.g. /opt/oracle/oradata/3902C3E72FEA00F9E063020011AC4B5A/music_schema.dmp)

## FOR IMPORT

docker exec -it musvinyl impdp system/DbForMusic_2025@localhost:1521/music_pdb \
DIRECTORY=DATA_PUMP_DIR \
DUMPFILE=music_schema.dmp \
LOGFILE=music_import.log \
REMAP_SCHEMA=music_owner:music_owner_restored


when successful, will print something like:
" 
Import: Release 23.0.0.0.0 - Production on Tue Jul 1 18:31:39 2025
Version 23.8.0.25.04

Copyright (c) 1982, 2025, Oracle and/or its affiliates.  All rights reserved.

Connected to: Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Master table "SYSTEM"."SYS_IMPORT_FULL_01" successfully loaded/unloaded
Starting "SYSTEM"."SYS_IMPORT_FULL_01":  system/********@localhost:1521/music_pdb DIRECTORY=DATA_PUMP_DIR DUMPFILE=music_schema.dmp LOGFILE=music_import.log REMAP_SCHEMA=music_owner:music_owner_restored
Processing object type SCHEMA_EXPORT/PRE_SCHEMA/PROCACT_SCHEMA/LOGREP
Processing object type SCHEMA_EXPORT/SEQUENCE/SEQUENCE
Processing object type SCHEMA_EXPORT/TABLE/TABLE
Processing object type SCHEMA_EXPORT/TABLE/TABLE_DATA
. . imported "MUSIC_OWNER_RESTORED"."RELEASES"             7.4 KB       4 rows
. . imported "MUSIC_OWNER_RESTORED"."ARTISTS"              7.1 KB       6 rows
. . imported "MUSIC_OWNER_RESTORED"."ALBUMS"               7.1 KB       3 rows
. . imported "MUSIC_OWNER_RESTORED"."TRACKS"                 7 KB       3 rows
. . imported "MUSIC_OWNER_RESTORED"."ARTIST_MEMBERS"       6.1 KB       4 rows
. . imported "MUSIC_OWNER_RESTORED"."LABELS"               6.1 KB       4 rows
. . imported "MUSIC_OWNER_RESTORED"."MEMBERS"              5.6 KB       4 rows
. . imported "MUSIC_OWNER_RESTORED"."TRACK_FEATURES"       5.6 KB       1 rows
Processing object type SCHEMA_EXPORT/PACKAGE/PACKAGE_SPEC
Processing object type SCHEMA_EXPORT/PACKAGE/GRANT/OWNER_GRANT/OBJECT_GRANT
Processing object type SCHEMA_EXPORT/PACKAGE/COMPILE_PACKAGE/PACKAGE_SPEC/ALTER_PACKAGE_SPEC
Processing object type SCHEMA_EXPORT/VIEW/VIEW
Processing object type SCHEMA_EXPORT/VIEW/GRANT/OWNER_GRANT/OBJECT_GRANT
Processing object type SCHEMA_EXPORT/PACKAGE/PACKAGE_BODY
Processing object type SCHEMA_EXPORT/TABLE/INDEX/INDEX
Processing object type SCHEMA_EXPORT/TABLE/CONSTRAINT/CONSTRAINT
Processing object type SCHEMA_EXPORT/TABLE/INDEX/STATISTICS/INDEX_STATISTICS
Processing object type SCHEMA_EXPORT/TABLE/CONSTRAINT/REF_CONSTRAINT
Processing object type SCHEMA_EXPORT/TABLE/TRIGGER
Processing object type SCHEMA_EXPORT/TABLE/STATISTICS/TABLE_STATISTICS
Job "SYSTEM"."SYS_IMPORT_FULL_01" successfully completed at Tue Jul 1 18:32:02 2025 elapsed 0 00:00:21
"

THEN:
docker cp music_schema.dmp musvinyl:/opt/oracle/oradata/





## LEGACY VERSIONS

### EXPORT 

docker exec -it musvinyl exp music_owner/YourAppPassword@localhost:1521/music_pdb FILE=music_schema_legacy.dmp OWNER=music_owner

docker cp musvinyl:/music_schema_legacy.dmp .


### IMPORT

docker cp music_schema_legacy.dmp musvinyl:/

docker exec -it musvinyl imp system/DbForMusic_2025@localhost:1521/music_pdb FILE=/music_schema_legacy.dmp FROMUSER=music_owner TOUSER=music_owner_restored