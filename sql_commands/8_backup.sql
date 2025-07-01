-- Create the directory object pointing to a valid path inside the container
-- RUN AS SYS
CREATE OR REPLACE DIRECTORY DATA_PUMP_DIR AS '/opt/oracle/oradata';

-- Grant read and write permissions on that directory to your application user
-- RUN AS SOLUTION (system in PDB)
GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO music_owner;





-- impdp
CREATE USER music_owner_restored IDENTIFIED BY NewPassword
  DEFAULT TABLESPACE music_ts
  QUOTA UNLIMITED ON music_ts;
GRANT CONNECT, RESOURCE TO music_owner_restored;


-- docker cp music_schema.dmp musvinyl:/opt/oracle/oradata/

-- Successfully copied 784kB to musvinyl:/opt/oracle/oradata




