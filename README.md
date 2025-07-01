Music Discography Database (orac-db-musvinyl)

A database project for the NDBI026 + DBI013 Credit Programme. This project catalogs musical artists, albums, members, and releases in an Oracle database, featuring a PL/SQL application layer for data management.

Full Setup and Demonstration Workflow

This guide provides all the necessary steps to set up the database environment, build the application schema, and test the functionality from a clean slate.

Step 1: Start the Database Container

Prerequisite: You must have Docker Desktop installed and running.

Open your command line terminal (PowerShell, CMD, or Terminal) and run the following command to download and start the Oracle database container.

docker run -d --name musvinyl -p 1521:1521 -e ORACLE_PASSWORD=DbForMusic_2025 gvenzl/oracle-free

Wait a few minutes for the database to initialize. You can check its progress with docker logs -f musvinyl. Wait for the message DATABASE IS READY TO USE! before proceeding.

Step 2: Environment Setup (as DBA)

This phase creates the Pluggable Database (PDB) and all necessary users, roles, and tablespaces.

    Connect as the SYS user to the root container. Use the following connection details in your SQL client (VS Code, SQL Developer, DBeaver, etc.):

        User: sys

        Password: DbForMusic_2025

        Role: SYSDBA

        Service Name: FREE (This is the service for the root container)

    Run the setup script. Once connected, execute the setup_environment.sql script.

    @setup_environment.sql

This script creates the music_pdb, the music_owner user, and the application roles.

Step 3: Build & Populate the Schema (as Application Owner)

In this phase, you will connect as the application owner to build the tables, packages, and insert the data.

    Connect as the music_owner user to your new PDB. Use these connection details:

        User: music_owner

        Password: YourAppPassword (The password you set in setup_environment.sql)

        Service Name: music_pdb

    Run the following scripts in this exact order:

        drop_schema.sql: Clears any old objects for a clean start.

        @drop_schema.sql

        super_create_schema.sql: Creates all tables, views, indexes, packages, and triggers.

        @super_create_schema.sql

        insert_data.sql: Populates the tables with sample data.

        @insert_data.sql

        grant_privs_to_roles.sql: Grants permissions on the new objects to the application roles.

        @grant_privs_to_roles.sql

Step 4: Test the Application

This final step runs the test script to verify that all procedures and triggers work as expected.

    While still connected as music_owner, run the test script:

    @test_functionality.sql

The output will show the results of each test case, including successful operations and correctly handled errors.

Appendix: Backup and Recovery

These commands are run from your computer's terminal to back up and restore the schema.

    To Back Up (expdp):

    docker exec -it musvinyl expdp music_owner/YourAppPassword@localhost:1521/music_pdb DIRECTORY=DATA_PUMP_DIR DUMPFILE=music_schema.dmp SCHEMAS=music_owner

    To Recover (impdp):

    docker exec -it musvinyl impdp system/DbForMusic_2025@localhost:1521/music_pdb DIRECTORY=DATA_PUMP_DIR DUMPFILE=music_schema.dmp REMAP_SCHEMA=music_owner:music_owner_restoredMusic Discography Database (orac-db-musvinyl)

A database project for the NDBI026 + DBI013 Credit Programme. This project catalogs musical artists, albums, members, and releases in an Oracle database, featuring a PL/SQL application layer for data management.

Full Setup and Demonstration Workflow

This guide provides all the necessary steps to set up the database environment, build the application schema, and test the functionality from a clean slate.

Step 1: Start the Database Container

Prerequisite: You must have Docker Desktop installed and running.

Open your command line terminal (PowerShell, CMD, or Terminal) and run the following command to download and start the Oracle database container.

docker run -d --name musvinyl -p 1521:1521 -e ORACLE_PASSWORD=DbForMusic_2025 gvenzl/oracle-free

Wait a few minutes for the database to initialize. You can check its progress with docker logs -f musvinyl. Wait for the message DATABASE IS READY TO USE! before proceeding.

Step 2: Environment Setup (as DBA)

This phase creates the Pluggable Database (PDB) and all necessary users, roles, and tablespaces.

    Connect as the SYS user to the root container. Use the following connection details in your SQL client (VS Code, SQL Developer, DBeaver, etc.):

        User: sys

        Password: DbForMusic_2025

        Role: SYSDBA

        Service Name: FREE (This is the service for the root container)

    Run the setup script. Once connected, execute the setup_environment.sql script.

    @setup_environment.sql

This script creates the music_pdb, the music_owner user, and the application roles.

Step 3: Build & Populate the Schema (as Application Owner)

In this phase, you will connect as the application owner to build the tables, packages, and insert the data.

    Connect as the music_owner user to your new PDB. Use these connection details:

        User: music_owner

        Password: YourAppPassword (The password you set in setup_environment.sql)

        Service Name: music_pdb

    Run the following scripts in this exact order:

        drop_schema.sql: Clears any old objects for a clean start.

        @drop_schema.sql

        super_create_schema.sql: Creates all tables, views, indexes, packages, and triggers.

        @super_create_schema.sql

        insert_data.sql: Populates the tables with sample data.

        @insert_data.sql

        grant_privs_to_roles.sql: Grants permissions on the new objects to the application roles.

        @grant_privs_to_roles.sql

Step 4: Test the Application

This final step runs the test script to verify that all procedures and triggers work as expected.

    While still connected as music_owner, run the test script:

    @test_functionality.sql

The output will show the results of each test case, including successful operations and correctly handled errors.

Appendix: Backup and Recovery

These commands are run from your computer's terminal to back up and restore the schema.

    To Back Up (expdp):

    docker exec -it musvinyl expdp music_owner/YourAppPassword@localhost:1521/music_pdb DIRECTORY=DATA_PUMP_DIR DUMPFILE=music_schema.dmp SCHEMAS=music_owner

    To Recover (impdp):

    docker exec -it musvinyl impdp system/DbForMusic_2025@localhost:1521/music_pdb DIRECTORY=DATA_PUMP_DIR DUMPFILE=music_schema.dmp REMAP_SCHEMA=music_owner:music_owner_restored