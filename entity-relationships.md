Entity-Relationship Model

The database consists of 8 interrelated tables, which is an ideal number for this project's scope.

    ARTISTS: The main table for bands or solo artists.

        ARTIST_ID (PK): Unique identifier for the artist.

        ARTIST_NAME: The name of the band or solo artist (e.g., "The Beatles", "Ozzy Osbourne").

        YEAR_FOUNDED: The year the artist/band was formed.

        IS_ACTIVE: A flag (Y/N) to indicate if the artist is currently active.

        BIOGRAPHY_URL: A link to a page with more information.


    MEMBERS: A table for individual musicians.

        MEMBER_ID (PK): Unique identifier for a person.

        FULL_NAME: The full name of the musician (e.g., "John Lennon").



    ARTIST_MEMBERS: A junction table linking members to artists (bands). This allows a member to be part of multiple bands.

        ARTIST_ID (FK): References ARTISTS.

        MEMBER_ID (FK): References MEMBERS.

        ROLE: The role in the band (e.g., "Lead Vocals", "Guitar").

        (PK: ARTIST_ID, MEMBER_ID)



    LABELS: Stores record labels.

        LABEL_ID (PK): Unique identifier for the label.

        LABEL_NAME: Name of the record label (e.g., "Apple Records", "Swan Song").

        FOUNDER_ARTIST_ID (FK): A nullable reference to the ARTISTS table for labels founded by an artist (e.g., Jimmy Page and Swan Song).



    ALBUMS: Core table for albums.

        ALBUM_ID (PK): Unique identifier for the album.

        TITLE: The album title (e.g., "Abbey Road").

        PRIMARY_ARTIST_ID (FK): The main artist who released the album. References ARTISTS.

        RELEASE_YEAR: The original year the album was released.

        PRODUCER: The name of the album's producer.



    RELEASES: Tracks specific physical or digital releases of an album.

        RELEASE_ID (PK): Unique identifier for a specific version.

        ALBUM_ID (FK): The album this is a version of. References ALBUMS.

        LABEL_ID (FK): The label for this specific release (e.g., Supraphon). References LABELS.

        RELEASE_DATE: The exact date of this version's release.

        FORMAT: The format of the release (e.g., "LP", "CD", "Digital").

        CATALOG_NUMBER: The catalog number for this specific release.



    TRACKS: Lists the songs on each album.

        TRACK_ID (PK): Unique identifier for a track.

        ALBUM_ID (FK): The album the track belongs to. References ALBUMS.

        TITLE: The title of the track (e.g., "Come Together").

        TRACK_NUMBER: The position of the track on the album.

        DURATION_SECONDS: Length of the track in seconds.

        

    TRACK_FEATURES: Junction table to manage guest appearances ("feat.").

        TRACK_ID (FK): The track featuring a guest. References TRACKS.

        GUEST_ARTIST_ID (FK): The guest artist. References ARTISTS.

        (PK: TRACK_ID, GUEST_ARTIST_ID)