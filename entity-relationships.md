Entity-Relationship Model

The database consists of 9 interrelated tables, designed to ensure data integrity and reflect real-world business rules.

    ARTISTS: The main table for bands or solo artists.

        ARTIST_ID (PK): Unique internal identifier for the artist.

        ARTIST_NAME (NK): The unique name of the band or solo artist.

        YEAR_FOUNDED: The year the artist/band was formed.

        IS_ACTIVE: A flag (Y/N) to indicate if the artist is currently active.

        BIOGRAPHY_URL: A link to a page with more information.

    MEMBERS: A table for individual musicians.

        MEMBER_ID (PK): Unique internal identifier for a person.

        FULL_NAME (NK): The unique full name of the musician.

    ARTIST_MEMBERS: A junction table linking members to artists (bands).

        ARTIST_ID (FK): References ARTISTS.

        MEMBER_ID (FK): References MEMBERS.

        ROLE: The role in the band (e.g., "Lead Vocals", "Guitar").

        (PK: ARTIST_ID, MEMBER_ID)

    LABELS: Stores record labels.

        LABEL_ID (PK): Unique internal identifier for the label.

        LABEL_NAME (NK): The unique name of the record label.

        FOUNDER_ARTIST_ID (FK): A nullable reference to ARTISTS for labels founded by an artist.

    ALBUMS: Core table for albums.

        ALBUM_ID (PK): Unique internal identifier for the album.

        TITLE: The album title.

        ALBUM_TYPE: The category of the album (e.g., 'Studio', 'Live', 'Compilation', 'Demo').

        PRIMARY_ARTIST_ID (FK): The main artist who released the album.

        RELEASE_YEAR: The original year the album was released.

        PRODUCER: The name of the album's producer.

        (NK: PRIMARY_ARTIST_ID, TITLE) - This is the real-world key preventing duplicate albums by the same artist.

    RELEASES: Tracks specific physical or digital releases of an album.

        RELEASE_ID (PK): Unique internal identifier for a specific version.

        ALBUM_ID (FK): The album this is a version of.

        LABEL_ID (FK): The label for this specific release.

        RELEASE_DATE: The exact date of this version's release.

        FORMAT: The format of the release (e.g., "LP", "CD", "Digital").

        CATALOG_NUMBER (NK): The unique catalog number for this specific release.

    TRACKS: Lists the songs on each album.

        TRACK_ID (PK): Unique internal identifier for a track.

        ALBUM_ID (FK): The album the track belongs to.

        TITLE: The title of the track.

        TRACK_NUMBER: The position of the track on the album.

        DURATION_SECONDS: Length of the track in seconds.

        (NK 1: ALBUM_ID, TITLE) - Prevents duplicate track titles on the same album.

        (NK 2: ALBUM_ID, TRACK_NUMBER) - Prevents two tracks from having the same number on the same album.

    TRACK_FEATURES: Junction table to manage guest appearances ("feat.").

        TRACK_ID (FK): The track featuring a guest.

        GUEST_ARTIST_ID (FK): The guest artist.

        (PK: TRACK_ID, GUEST_ARTIST_ID)

    ARTISTS_AUDIT: An audit table to log changes to artist status.

        AUDIT_ID (PK): Unique identifier for the audit record.

        ARTIST_ID: The ID of the artist who was changed.

        OLD_STATUS: The is_active value before the change.

        NEW_STATUS: The is_active value after the change.

        CHANGE_USER: The database user who performed the update.

        CHANGE_TIMESTAMP: The exact time the update occurred.
