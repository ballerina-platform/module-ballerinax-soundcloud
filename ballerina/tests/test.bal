// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.


import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.soundcloud.com" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("SOUNDCLOUD_ACCESS_TOKEN") : "test_token";
final string liveTrackUrn = isLiveServer ? os:getEnv("SOUNDCLOUD_TRACK_URN") : "soundcloud:tracks:98765";
final string liveUserUrn = isLiveServer ? os:getEnv("SOUNDCLOUD_USER_URN") : "soundcloud:users:1234";
final string livePlaylistUrn = isLiveServer ? os:getEnv("SOUNDCLOUD_PLAYLIST_URN") : "soundcloud:playlists:5544";

final Client soundcloud = check new ({auth: {token}, httpVersion: http:HTTP_1_1}, serviceUrl);

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetMe() returns error? {
    Me me = check soundcloud->getMe();
    test:assertTrue(me?.urn is string);
    test:assertTrue(me?.username is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListMyTracks() returns error? {
    TracksResult tracks = check soundcloud->listMyTracks(linkedPartitioning = true);
    test:assertTrue(tracks is Tracks || tracks is TracksList);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListMyPlaylists() returns error? {
    PlaylistsResult playlists = check soundcloud->listMyPlaylists(linkedPartitioning = true);
    test:assertTrue(playlists is Playlists || playlists is PlaylistsArray);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListMyFollowings() returns error? {
    Users users = check soundcloud->listMyFollowings();
    test:assertTrue((users?.collection ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testFollowUser() returns error? {
    if isLiveServer {
        return;
    }
    json|User result = check soundcloud->followUser(liveUserUrn);
    test:assertTrue(result is User || result is json);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testUnfollowUser() returns error? {
    if isLiveServer {
        return;
    }
    json result = check soundcloud->unfollowUser(liveUserUrn);
    test:assertTrue(result is map<json>);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testSearchTracks() returns error? {
    TracksResult tracks = check soundcloud->searchTracks(q = "drive", linkedPartitioning = true);
    test:assertTrue(tracks is Tracks || tracks is TracksList);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetTrack() returns error? {
    Track track = check soundcloud->getTrack(liveTrackUrn);
    test:assertTrue(track?.urn is string);
    test:assertTrue(track?.title is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testUpdateTrack() returns error? {
    if isLiveServer {
        return;
    }
    Track track = check soundcloud->updateTrack(liveTrackUrn, {track: {description: "Updated description"}});
    test:assertTrue(track?.urn is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListUserFollowers() returns error? {
    Users users = check soundcloud->listUserFollowers(liveUserUrn);
    test:assertTrue((users?.collection ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListTrackComments() returns error? {
    Comments comments = check soundcloud->listTrackComments(liveTrackUrn);
    test:assertTrue((comments?.collection ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateTrackComment() returns error? {
    if isLiveServer {
        return;
    }
    Comment comment = check soundcloud->createTrackComment(liveTrackUrn, {comment: {body: "Nice track!", timestamp: "1000"}});
    test:assertEquals(comment?.body, "Nice track!");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListTrackFavoriters() returns error? {
    Users users = check soundcloud->listTrackFavoriters(liveTrackUrn);
    test:assertTrue((users?.collection ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListRelatedTracks() returns error? {
    TracksResult tracks = check soundcloud->listRelatedTracks(liveTrackUrn, linkedPartitioning = true);
    test:assertTrue(tracks is Tracks || tracks is TracksList);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testSearchPlaylists() returns error? {
    PlaylistsResult playlists = check soundcloud->searchPlaylists(q = "night", linkedPartitioning = true);
    test:assertTrue(playlists is Playlists || playlists is PlaylistsArray);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreatePlaylist() returns error? {
    if isLiveServer {
        return;
    }
    Playlist playlist = check soundcloud->createPlaylist({playlist: {title: "Road Trip", tracks: [{urn: liveTrackUrn}]}});
    test:assertEquals(playlist?.title, "Road Trip");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetPlaylist() returns error? {
    Playlist playlist = check soundcloud->getPlaylist(livePlaylistUrn);
    test:assertTrue(playlist?.urn is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testUpdatePlaylist() returns error? {
    if isLiveServer {
        return;
    }
    Playlist playlist = check soundcloud->updatePlaylist(livePlaylistUrn, {playlist: {title: "Renamed Playlist"}});
    test:assertEquals(playlist?.title, "Renamed Playlist");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDeletePlaylist() returns error? {
    if isLiveServer {
        return;
    }
    Playlist created = check soundcloud->createPlaylist({playlist: {title: "Temporary Playlist"}});
    string playlistUrn = created?.urn ?: "";
    test:assertTrue(playlistUrn != "");
    error? result = soundcloud->deletePlaylist(playlistUrn);
    test:assertTrue(result is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListPlaylistTracks() returns error? {
    TracksResult tracks = check soundcloud->listPlaylistTracks(livePlaylistUrn, linkedPartitioning = true);
    test:assertTrue(tracks is Tracks || tracks is TracksList);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testSearchUsers() returns error? {
    Users users = check soundcloud->searchUsers(q = "some");
    test:assertTrue((users?.collection ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetUser() returns error? {
    User user = check soundcloud->getUser(liveUserUrn);
    test:assertTrue(user?.username is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListUserTracks() returns error? {
    TracksResult tracks = check soundcloud->listUserTracks(liveUserUrn, linkedPartitioning = true);
    test:assertTrue(tracks is Tracks || tracks is TracksList);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testLikeTrack() returns error? {
    if isLiveServer {
        return;
    }
    json result = check soundcloud->likeTrack(liveTrackUrn);
    test:assertTrue(result is map<json>);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testUnlikeTrack() returns error? {
    if isLiveServer {
        return;
    }
    json result = check soundcloud->unlikeTrack(liveTrackUrn);
    test:assertTrue(result is map<json>);
}
