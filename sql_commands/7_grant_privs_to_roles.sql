-- SCRIPT: grant_privs_to_roles.sql
-- PURPOSE: To grant object-level privileges to the application roles.
-- MUST BE RUN AS music_owner AFTER the schema is created.

-- =================================================================
-- Grant privileges to the read-only role
-- =================================================================
PROMPT -- Granting privileges to 'music_app_user_role'...
GRANT SELECT ON V_ARTIST_DISCOGRAPHY TO music_app_user_role;
GRANT SELECT ON V_ALBUM_DETAILS TO music_app_user_role;
GRANT SELECT ON V_ARTIST_COLLABORATIONS TO music_app_user_role;

-- =================================================================
-- Grant privileges to the admin role
-- =================================================================
PROMPT -- Granting privileges to 'music_app_admin_role'...
GRANT EXECUTE ON artist_pkg TO music_app_admin_role;
GRANT EXECUTE ON album_pkg TO music_app_admin_role;

PROMPT -- Role privileges granted. --
