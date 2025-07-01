-- SCRIPT: setup_environment.sql
-- PURPOSE: To create a new PDB and configure all necessary users, roles, and tablespaces.
-- MUST BE RUN AS SYSDBA.

-- =================================================================
-- Step 1: Create a new Pluggable Database (PDB) from the SEED
-- =================================================================
PROMPT -- Creating Pluggable Database 'music_pdb'...
CREATE PLUGGABLE DATABASE music_pdb
  ADMIN USER pdb_admin IDENTIFIED BY YourAdminPassword
  ROLES = (DBA)
  FILE_NAME_CONVERT = ('/opt/oracle/oradata/FREE/pdbseed/', '/opt/oracle/oradata/FREE/music_pdb/');

-- =================================================================
-- Step 2: Open the new PDB and ensure it starts automatically
-- =================================================================
PROMPT -- Opening 'music_pdb' and saving state...
ALTER PLUGGABLE DATABASE music_pdb OPEN;
ALTER PLUGGABLE DATABASE music_pdb SAVE STATE;

-- =================================================================
-- Step 3: Switch to the new PDB to perform local setup
-- =================================================================
PROMPT -- Switching session to container 'music_pdb'...
ALTER SESSION SET CONTAINER = music_pdb;

-- =================================================================
-- Step 4: Create a dedicated tablespace for application data
-- =================================================================
PROMPT -- Creating tablespace 'music_ts'...
CREATE TABLESPACE music_ts 
  DATAFILE '/opt/oracle/oradata/FREE/music_pdb/music_ts01.dbf' 
  SIZE 100M AUTOEXTEND ON;

-- =================================================================
-- Step 5: Create and configure the data owner for the application
-- =================================================================
PROMPT -- Creating data owner 'music_owner'...
CREATE USER music_owner IDENTIFIED BY YourAppPassword
  DEFAULT TABLESPACE music_ts
  QUOTA UNLIMITED ON music_ts;

PROMPT -- Granting privileges to 'music_owner'...
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE PROCEDURE, CREATE TRIGGER TO music_owner;

-- =================================================================
-- Step 6: Create the required roles for the application
-- =================================================================
PROMPT -- Creating application roles...
CREATE ROLE music_app_user_role;
CREATE ROLE music_app_admin_role;

-- =================================================================
-- Step 7: Create a sample application user and assign a role
-- =================================================================
PROMPT -- Creating sample application user 'app_user1'...
CREATE USER app_user1 IDENTIFIED BY AnotherPassword;

PROMPT -- Assigning role to 'app_user1'...
GRANT music_app_user_role TO app_user1;

PROMPT -- Environment setup complete. --