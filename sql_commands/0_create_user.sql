-- Create the user (schema owner) for your music application
CREATE USER music_owner IDENTIFIED BY DbForMusic_2025;

-- Grant the user the necessary permissions to create tables, views, procedures, etc.
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE PROCEDURE, CREATE TRIGGER TO music_owner;

-- Give the user space to store data in the default tablespace
ALTER USER music_owner QUOTA UNLIMITED ON USERS;



-- change user's password
ALTER USER music_owner IDENTIFIED BY user;