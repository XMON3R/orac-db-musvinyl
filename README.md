# orac-db-musvinyl
NDBI026 + DBI013 Credit Programme


How?
- Docker Oracle

docker run -d --name oracle-db -p 1521:1521 -e ORACLE_PASSWORD=YourSecurePassword1 gvenzl/oracle-free


/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TÍMTO VŠE ZAČNE:

docker run -d --name musvinyl -p 1521:1521 -e ORACLE_PASSWORD=DbForMusic_2025 gvenzl/oracle-free


PŘIPOJENÍ (SYSTEM):
Connection Name: musvinyl_admin

Username: SYSTEM

Password: DbForMusic_2025

Role: Default

Connection Type: Basic

Hostname: localhost

Port: 1521

Service Name: FREEPDB1

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

PO PŘIPOJENÍ:
create_user.sql
(User MUSIC_OWNER created.


Grant succeeded.


User MUSIC_OWNER altered.)


VYTVOŘENÍ DALŠÍCH UŽIVATELŮ:
(normální user)

Connection Name: musvinyl_as_user

Username: music_owner

Password: user

Hostname: localhost

Port: 1521

Service Name: FREEPDB1