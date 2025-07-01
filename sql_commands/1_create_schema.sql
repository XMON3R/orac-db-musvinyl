-- Sequence and Table for ARTISTS
CREATE SEQUENCE artists_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE artists (
    artist_id NUMBER PRIMARY KEY,
    artist_name VARCHAR2(200) NOT NULL UNIQUE,
    year_founded NUMBER(4),
    is_active CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y', 'N')),
    biography_url VARCHAR2(500)
);

-- Sequence and Table for MEMBERS
CREATE SEQUENCE members_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE members (
    member_id NUMBER PRIMARY KEY,
    full_name VARCHAR2(200) NOT NULL UNIQUE
);

-- Junction Table for ARTIST_MEMBERS (links members to artists/bands)
CREATE TABLE artist_members (
    artist_id NUMBER NOT NULL,
    member_id NUMBER NOT NULL,
    role VARCHAR2(100),
    CONSTRAINT pk_artist_members PRIMARY KEY (artist_id, member_id),
    CONSTRAINT fk_am_artist FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
    CONSTRAINT fk_am_member FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Sequence and Table for LABELS
CREATE SEQUENCE labels_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE labels (
    label_id NUMBER PRIMARY KEY,
    label_name VARCHAR2(200) NOT NULL UNIQUE,
    founder_artist_id NUMBER,
    CONSTRAINT fk_label_founder FOREIGN KEY (founder_artist_id) REFERENCES artists(artist_id)
);

-- Sequence and Table for ALBUMS
CREATE SEQUENCE albums_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE albums (
    album_id NUMBER PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    primary_artist_id NUMBER NOT NULL,
    release_year NUMBER(4) NOT NULL,
    producer VARCHAR2(200),
    CONSTRAINT fk_album_artist FOREIGN KEY (primary_artist_id) REFERENCES artists(artist_id)
);

-- Sequence and Table for RELEASES (specific versions of an album)
CREATE SEQUENCE releases_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE releases (
    release_id NUMBER PRIMARY KEY,
    album_id NUMBER NOT NULL,
    label_id NUMBER NOT NULL,
    release_date DATE,
    format VARCHAR2(50) NOT NULL,
    catalog_number VARCHAR2(100),
    CONSTRAINT fk_release_album FOREIGN KEY (album_id) REFERENCES albums(album_id),
    CONSTRAINT fk_release_label FOREIGN KEY (label_id) REFERENCES labels(label_id)
);

-- Sequence and Table for TRACKS
CREATE SEQUENCE tracks_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE tracks (
    track_id NUMBER PRIMARY KEY,
    album_id NUMBER NOT NULL,
    title VARCHAR2(200) NOT NULL,
    track_number NUMBER,
    duration_seconds NUMBER,
    CONSTRAINT fk_track_album FOREIGN KEY (album_id) REFERENCES albums(album_id)
);

-- Junction Table for TRACK_FEATURES (guest artists on tracks)
CREATE TABLE track_features (
    track_id NUMBER NOT NULL,
    guest_artist_id NUMBER NOT NULL,
    CONSTRAINT pk_track_features PRIMARY KEY (track_id, guest_artist_id),
    CONSTRAINT fk_tf_track FOREIGN KEY (track_id) REFERENCES tracks(track_id),
    CONSTRAINT fk_tf_artist FOREIGN KEY (guest_artist_id) REFERENCES artists(artist_id)
);