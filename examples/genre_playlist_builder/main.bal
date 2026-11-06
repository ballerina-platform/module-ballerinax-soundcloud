// Searches SoundCloud for tracks of a genre, collects them into a new playlist and lists the result.

import ballerina/io;
import ballerinax/soundcloud;

configurable string accessToken = ?;
configurable string genre = "synthwave";
configurable string searchTerm = "night drive";
configurable int maxTracks = 5;
configurable boolean createPlaylist = false;

public function main() returns error? {
    soundcloud:Client soundcloudClient = check new ({auth: {authorization: "OAuth " + accessToken}});

    // Step 1: Search tracks that match the genre and search term.
    soundcloud:TracksResult searchResult = check soundcloudClient->searchTracks(
        q = searchTerm, genres = genre, 'limit = maxTracks, linkedPartitioning = true);
    soundcloud:Track[] candidates = [];
    if searchResult is soundcloud:Tracks {
        candidates = searchResult?.collection ?: [];
    } else {
        candidates = searchResult;
    }
    if candidates.length() == 0 {
        return error("No tracks found for genre '" + genre + "' and term '" + searchTerm + "'");
    }
    io:println("Found ", candidates.length(), " candidate tracks:");
    soundcloud:CreateUpdatePlaylistRequestPlaylistTracks[] playlistTracks = [];
    foreach soundcloud:Track candidate in candidates {
        string? urn = candidate?.urn;
        if urn is string {
            playlistTracks.push({urn});
            io:println("  - ", candidate?.title ?: "(untitled)", " [", urn, "]");
        }
    }

    // Step 2: Create a private playlist from the selected tracks (side effect, opt in via Config.toml).
    if !createPlaylist {
        io:println("Set createPlaylist = true in Config.toml to create the playlist.");
        return;
    }
    soundcloud:Playlist playlist = check soundcloudClient->createPlaylist({
        playlist: {
            title: genre + " picks",
            description: "Tracks collected for the search term '" + searchTerm + "'",
            sharing: "private",
            tracks: playlistTracks
        }
    });
    string playlistUrn = playlist?.urn ?: "";
    if playlistUrn == "" {
        return error("The created playlist has no URN");
    }
    io:println("Created playlist ", playlistUrn);

    // Step 3: Read the playlist's tracks back.
    soundcloud:TracksResult playlistTracksResult = check soundcloudClient->listPlaylistTracks(playlistUrn, linkedPartitioning = true);
    soundcloud:Track[] stored = [];
    if playlistTracksResult is soundcloud:Tracks {
        stored = playlistTracksResult?.collection ?: [];
    } else {
        stored = playlistTracksResult;
    }
    io:println("The playlist now holds ", stored.length(), " tracks.");
}
