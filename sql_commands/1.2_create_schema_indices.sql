-- SCRIPT PART: Index Creation
-- PURPOSE: To improve query performance on table joins.

-- Indexes for ARTIST_MEMBERS table
CREATE INDEX idx_am_artist_id ON artist_members(artist_id);
CREATE INDEX idx_am_member_id ON artist_members(member_id);

-- Index for LABELS table
CREATE INDEX idx_label_founder_id ON labels(founder_artist_id);

-- Index for ALBUMS table
CREATE INDEX idx_album_artist_id ON albums(primary_artist_id);

-- Indexes for RELEASES table
CREATE INDEX idx_release_album_id ON releases(album_id);
CREATE INDEX idx_release_label_id ON releases(label_id);

-- Index for TRACKS table
CREATE INDEX idx_track_album_id ON tracks(album_id);

-- Indexes for TRACK_FEATURES table
CREATE INDEX idx_tf_track_id ON track_features(track_id);
CREATE INDEX idx_tf_guest_artist_id ON track_features(guest_artist_id)


