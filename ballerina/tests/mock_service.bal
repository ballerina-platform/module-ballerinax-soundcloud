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

import ballerina/data.jsondata;
import ballerina/http;

listener http:Listener ep0 = new (9090);

final readonly & User mockUser = {
    kind: "user",
    urn: "soundcloud:users:1234",
    username: "some.user",
    fullName: "Some User",
    firstName: "Some",
    lastName: "User",
    permalink: "some-user",
    permalinkUrl: "https://soundcloud.com/some-user",
    uri: "https://api.soundcloud.com/users/1234",
    avatarUrl: "https://i1.sndcdn.com/avatars-000000001234-abcdef-large.jpg",
    city: "Berlin",
    country: "Germany",
    description: "Electronic music producer",
    followersCount: 120,
    followingsCount: 45,
    trackCount: 12,
    playlistCount: 3,
    publicFavoritesCount: 20,
    repostsCount: 4,
    createdAt: "2016/05/12 10:30:00 +0000",
    lastModified: "2026/01/15 08:12:00 +0000"
};

final readonly & Track mockTrack = {
    kind: "track",
    urn: "soundcloud:tracks:98765",
    title: "Midnight Drive",
    description: "A late night synthwave track",
    genre: "Synthwave",
    tagList: "synthwave retro night",
    duration: 215000,
    createdAt: "2025/11/02 21:00:00 +0000",
    sharing: "public",
    license: "all-rights-reserved",
    access: "playable",
    streamable: true,
    downloadable: false,
    commentable: true,
    playbackCount: 5400,
    favoritingsCount: 310,
    commentCount: 27,
    repostsCount: 15,
    uri: "https://api.soundcloud.com/tracks/98765",
    permalinkUrl: "https://soundcloud.com/some-user/midnight-drive",
    artworkUrl: "https://i1.sndcdn.com/artworks-000098765-abc-large.jpg",
    waveformUrl: "https://wave.sndcdn.com/abc_m.png",
    streamUrl: "https://api.soundcloud.com/tracks/98765/stream",
    user: mockUser
};

final readonly & Track mockTrack2 = {
    kind: "track",
    urn: "soundcloud:tracks:98766",
    title: "Sunrise Loop",
    description: "Ambient morning loop",
    genre: "Ambient",
    tagList: "ambient morning",
    duration: 180000,
    createdAt: "2025/12/10 07:15:00 +0000",
    sharing: "public",
    access: "playable",
    streamable: true,
    playbackCount: 1200,
    favoritingsCount: 85,
    commentCount: 6,
    uri: "https://api.soundcloud.com/tracks/98766",
    permalinkUrl: "https://soundcloud.com/some-user/sunrise-loop",
    user: mockUser
};

final readonly & Playlist mockPlaylist = {
    kind: "playlist",
    urn: "soundcloud:playlists:5544",
    title: "Night Rides",
    description: "Tracks for driving after dark",
    genre: "Synthwave",
    sharing: "public",
    'type: "compilation",
    playlistType: "playlist",
    trackCount: 2,
    duration: 395000,
    likesCount: 42,
    createdAt: "2026/01/05 18:00:00 +0000",
    lastModified: "2026/02/01 09:00:00 +0000",
    uri: "https://api.soundcloud.com/playlists/5544",
    permalink: "night-rides",
    permalinkUrl: "https://soundcloud.com/some-user/sets/night-rides",
    userUrn: "soundcloud:users:1234",
    user: mockUser,
    tracks: [mockTrack, mockTrack2]
};

final readonly & Comment mockComment = {
    kind: "comment",
    urn: "soundcloud:comments:7001",
    body: "Great drop at 1:20!",
    timestamp: "80000",
    createdAt: "2026/02/03 12:45:10 +0000",
    trackUrn: "soundcloud:tracks:98765",
    userUrn: "soundcloud:users:1234",
    uri: "https://api.soundcloud.com/comments/7001",
    user: {
        kind: "user",
        urn: "soundcloud:users:1234",
        username: "some.user",
        permalink: "some-user",
        permalinkUrl: "https://soundcloud.com/some-user",
        uri: "https://api.soundcloud.com/users/1234"
    }
};

final readonly & Error mockError = {code: 404, message: "Resource not found", link: "https://developers.soundcloud.com/docs/api/guide"};

service / on ep0 {
    # Unlikes a track.
    #
    # + trackUrn - SoundCloud Track id
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    resource function delete likes/tracks/[string trackUrn]() returns json|ErrorBadRequest|ErrorNotFound {
        return {status: "ok", urn: trackUrn};
    }

    # Deletes a user who is followed by the authenticated user.
    #
    # + userUrn - SoundCloud User id
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    # http:UnprocessableEntity (Unprocessable Entity)
    resource function delete me/followings/[string userUrn]() returns json|ErrorUnauthorized|ErrorNotFound|ErrorUnprocessableEntity {
        return {status: "ok", urn: userUrn};
    }

    # Deletes a playlist.
    #
    # + playlistUrn - SoundCloud playlist id
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:NotFound (Not Found)
    resource function delete playlists/[string playlistUrn]() returns http:Ok|ErrorNotFound {
        return http:OK;
    }

    # Returns the authenticated user’s information.
    #
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    resource function get me() returns Me|ErrorUnauthorized {
        return {
            kind: "user",
            urn: "soundcloud:users:1234",
            username: "some.user",
            fullName: "Some User",
            permalink: "some-user",
            permalinkUrl: "https://soundcloud.com/some-user",
            uri: "https://api.soundcloud.com/users/1234",
            plan: "Free",
            followersCount: 120,
            followingsCount: 45,
            trackCount: 12,
            playlistCount: 3,
            primaryEmailConfirmed: true,
            quota: {unlimitedUploadQuota: false, uploadSecondsLeft: 10800, uploadSecondsUsed: 1200}
        };
    }

    # Returns a list of users who are followed by the authenticated user.
    #
    # + 'limit - Number of results to return in the collection
    # + offset - Offset of the first result
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    resource function get me/followings(int 'limit = 50, int offset = 0) returns Users|ErrorUnauthorized {
        return {collection: [mockUser], nextHref: "https://api.soundcloud.com/me/followings?cursor=abc"};
    }

    # Returns user’s playlists (sets).
    #
    # + showTracks - Whether to include tracks in the playlists
    # + linkedPartitioning - Returns a paginated collection when true
    # + 'limit - Number of results to return in the collection
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    resource function get me/playlists(@http:Query {name: "show_tracks"} boolean? showTracks, @http:Query {name: "linked_partitioning"} boolean? linkedPartitioning, int 'limit = 50) returns PlaylistsResult|ErrorUnauthorized|ErrorNotFound {
        Playlists page = {collection: [mockPlaylist], nextHref: "https://api.soundcloud.com/me/playlists?cursor=abc"};
        return page;
    }

    # Returns a list of a given user's tracks.
    #
    # + linkedPartitioning - Returns a paginated collection when true
    # + 'limit - Number of results to return in the collection
    # + sort - Sort order of the results
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    resource function get me/tracks(@http:Query {name: "linked_partitioning"} boolean? linkedPartitioning, int 'limit = 50, "asc"|"desc" sort = "desc") returns TracksResult|ErrorUnauthorized {
        Tracks page = {collection: [mockTrack, mockTrack2], nextHref: "https://api.soundcloud.com/me/tracks?cursor=abc"};
        return page;
    }

    # Performs a playlist search based on a query
    #
    # + q - Search term
    # + access - Filter by access level
    # + showTracks - Whether to include tracks in the playlists
    # + linkedPartitioning - Returns a paginated collection when true
    # + 'limit - Number of results to return in the collection
    # + offset - Offset of the first result
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    resource function get playlists(string? q, ("playable"|"preview"|"blocked")[]? access, @http:Query {name: "show_tracks"} boolean? showTracks, @http:Query {name: "linked_partitioning"} boolean? linkedPartitioning, int 'limit = 50, int offset = 0) returns PlaylistsResult|ErrorBadRequest|ErrorUnauthorized {
        Playlists page = {collection: [mockPlaylist], nextHref: "https://api.soundcloud.com/playlists?cursor=abc"};
        return page;
    }

    # Returns a playlist.
    #
    # + playlistUrn - SoundCloud playlist id
    # + secretToken - Secret token of a private playlist
    # + access - Filter tracks by access level
    # + showTracks - Whether to include tracks in the playlist
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    resource function get playlists/[string playlistUrn](@http:Query {name: "secret_token"} string? secretToken, ("playable"|"preview"|"blocked")[]? access, @http:Query {name: "show_tracks"} boolean? showTracks) returns Playlist|ErrorBadRequest|ErrorUnauthorized {
        Playlist playlist = {...mockPlaylist};
        playlist.urn = playlistUrn;
        return playlist;
    }

    # Returns tracks under a playlist.
    #
    # + playlistUrn - SoundCloud playlist id
    # + secretToken - Secret token of a private playlist
    # + access - Filter tracks by access level
    # + linkedPartitioning - Returns a paginated collection when true
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    resource function get playlists/[string playlistUrn]/tracks(@http:Query {name: "secret_token"} string? secretToken, ("playable"|"preview"|"blocked")[]? access, @http:Query {name: "linked_partitioning"} boolean? linkedPartitioning) returns TracksResult|ErrorBadRequest|ErrorUnauthorized {
        Tracks page = {collection: [mockTrack, mockTrack2], nextHref: "https://api.soundcloud.com/playlists/5544/tracks?cursor=abc"};
        return page;
    }

    # Performs a track search based on a query
    #
    # + q - Search term
    # + urns - Comma separated track URNs
    # + genres - Comma separated genres
    # + tags - Comma separated tags
    # + bpm - Beats per minute filter
    # + duration - Duration filter
    # + createdAt - Creation time filter
    # + access - Filter by access level
    # + linkedPartitioning - Returns a paginated collection when true
    # + 'limit - Number of results to return in the collection
    # + offset - Offset of the first result
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:InternalServerError (Internal Server Error)
    resource function get tracks(string? q, string? urns, string? genres, string? tags, bpm? bpm, duration? duration, @http:Query {name: "created_at"} created_at? createdAt, ("playable"|"preview"|"blocked")[]? access, @http:Query {name: "linked_partitioning"} boolean? linkedPartitioning, int 'limit = 50, int offset = 0) returns TracksResult|ErrorBadRequest|ErrorUnauthorized|http:InternalServerError {
        Tracks page = {collection: [mockTrack, mockTrack2], nextHref: "https://api.soundcloud.com/tracks?cursor=abc"};
        return page;
    }

    # Returns a track.
    #
    # + trackUrn - SoundCloud Track urn
    # + secretToken - Secret token of a private track
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    resource function get tracks/[string trackUrn](@http:Query {name: "secret_token"} string? secretToken) returns Track|ErrorUnauthorized|ErrorNotFound {
        Track track = {...mockTrack};
        track.urn = trackUrn;
        return track;
    }

    # Returns the comments posted on the track(track_urn).
    #
    # + trackUrn - SoundCloud Track urn
    # + linkedPartitioning - Returns a paginated collection when true
    # + 'limit - Number of results to return in the collection
    # + offset - Offset of the first result
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    resource function get tracks/[string trackUrn]/comments(@http:Query {name: "linked_partitioning"} boolean? linkedPartitioning, int 'limit = 50, int offset = 0) returns Comments|ErrorUnauthorized|ErrorNotFound {
        return {collection: [mockComment], nextHref: ()};
    }

    # Returns a list of users who have favorited or liked the track.
    #
    # + trackUrn - SoundCloud Track urn
    # + linkedPartitioning - Returns a paginated collection when true
    # + 'limit - Number of results to return in the collection
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    resource function get tracks/[string trackUrn]/favoriters(@http:Query {name: "linked_partitioning"} boolean? linkedPartitioning, int 'limit = 50) returns Users|ErrorUnauthorized|ErrorNotFound {
        return {collection: [mockUser], nextHref: "https://api.soundcloud.com/tracks/98765/favoriters?cursor=abc"};
    }

    # Returns all related tracks of track on SoundCloud.
    #
    # + trackUrn - SoundCloud Track urn
    # + access - Filter by access level
    # + linkedPartitioning - Returns a paginated collection when true
    # + 'limit - Number of results to return in the collection
    # + offset - Offset of the first result
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    resource function get tracks/[string trackUrn]/related(("playable"|"preview"|"blocked")[]? access, @http:Query {name: "linked_partitioning"} boolean? linkedPartitioning, int 'limit = 50, int offset = 0) returns TracksResult|ErrorUnauthorized|ErrorNotFound {
        Tracks page = {collection: [mockTrack2], nextHref: "https://api.soundcloud.com/tracks/98765/related?cursor=abc"};
        return page;
    }

    # Performs a user search based on a query
    #
    # + q - Search term
    # + urns - Comma separated user URNs
    # + linkedPartitioning - Returns a paginated collection when true
    # + 'limit - Number of results to return in the collection
    # + offset - Offset of the first result
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    resource function get users(string? q, string? urns, @http:Query {name: "linked_partitioning"} boolean? linkedPartitioning, int 'limit = 50, int offset = 0) returns Users|ErrorBadRequest|ErrorUnauthorized {
        return {collection: [mockUser], nextHref: "https://api.soundcloud.com/users?cursor=abc"};
    }

    # Returns a list of user’s followers.
    #
    # + userUrn - SoundCloud User id
    # + 'limit - Number of results to return in the collection
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    resource function get users/[string userUrn]/followers(int 'limit = 50) returns Users|ErrorUnauthorized {
        return {collection: [mockUser], nextHref: "https://api.soundcloud.com/users/1234/followers?cursor=abc"};
    }


    # Returns a user.
    #
    # + userUrn - SoundCloud User id
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    resource function get users/[string userUrn]() returns User|ErrorUnauthorized|ErrorNotFound {
        User user = {...mockUser};
        user.urn = userUrn;
        return user;
    }

    # Returns a list of a given user's tracks.
    #
    # + userUrn - SoundCloud User id
    # + access - Filter by access level
    # + linkedPartitioning - Returns a paginated collection when true
    # + 'limit - Number of results to return in the collection
    # + sort - Sort order of the results
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    resource function get users/[string userUrn]/tracks(("playable"|"preview"|"blocked")[]? access, @http:Query {name: "linked_partitioning"} boolean? linkedPartitioning, int 'limit = 50, "asc"|"desc" sort = "desc") returns TracksResult|ErrorUnauthorized {
        Tracks page = {collection: [mockTrack, mockTrack2], nextHref: "https://api.soundcloud.com/users/1234/tracks?cursor=abc"};
        return page;
    }

    # Likes a track.
    #
    # + trackUrn - SoundCloud Track urn
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    # http:TooManyRequests (Too Many Requests)
    resource function post likes/tracks/[string trackUrn]() returns JsonOk|ErrorBadRequest|ErrorUnauthorized|ErrorNotFound|TooManyRequestsTooManyRequests {
        JsonOk ok = {body: {status: "ok", urn: trackUrn}};
        return ok;
    }

    # Creates a playlist.
    #
    # + request - The request body
    # + return - returns can be any of following types 
    # http:Created (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    resource function post playlists(http:Request request) returns Playlist|ErrorUnauthorized|ErrorNotFound {
        json|error body = request.getJsonPayload();
        string title = "New Playlist";
        if body is map<json> {
            json playlistJson = body["playlist"];
            if playlistJson is map<json> {
                json t = playlistJson["title"];
                if t is string {
                    title = t;
                }
            }
        }
        Playlist playlist = {...mockPlaylist};
        playlist.title = title;
        playlist.urn = "soundcloud:playlists:5599";
        return playlist;
    }

    # Creates a comment on a track.
    #
    # + trackUrn - SoundCloud Track urn
    # + payload - Body of a comment 
    # + return - returns can be any of following types 
    # http:Created (Success)
    # http:UnprocessableEntity (Unprocessable Entity)
    # http:TooManyRequests (Too Many Requests)
    resource function post tracks/[string trackUrn]/comments(@http:Payload CreateTrackCommentRequest payload) returns Comment|ErrorUnprocessableEntity|TooManyRequestsTooManyRequests {
        string body = payload.comment?.body ?: "";
        Comment comment = {...mockComment};
        comment.trackUrn = trackUrn;
        comment.body = body;
        return comment;
    }

    # Follows a user.
    #
    # + userUrn - SoundCloud User id
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Created (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    # http:UnprocessableEntity (Unprocessable Entity)
    resource function put me/followings/[string userUrn]() returns json|UserCreated|ErrorUnauthorized|ErrorNotFound|ErrorUnprocessableEntity {
        User followed = {...mockUser};
        followed.urn = userUrn;
        UserCreated created = {body: followed};
        return created;
    }

    # Updates a playlist.
    #
    # + playlistUrn - SoundCloud playlist id
    # + payload - Playlist attributes to update
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    resource function put playlists/[string playlistUrn](@http:Payload CreateUpdatePlaylistRequest payload) returns Playlist|ErrorUnauthorized|ErrorNotFound {
        string title = payload.playlist?.title ?: mockPlaylist.title ?: "Night Rides";
        Playlist playlist = {...mockPlaylist};
        playlist.urn = playlistUrn;
        playlist.title = title;
        return playlist;
    }

    # Updates a track's information.
    #
    # + trackUrn - SoundCloud Track urn
    # + request - The request body
    # + return - returns can be any of following types 
    # http:Ok (Success)
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    resource function put tracks/[string trackUrn](http:Request request) returns Track|ErrorBadRequest|ErrorUnauthorized {
        json|error body = request.getJsonPayload();
        string title = "Midnight Drive";
        if body is map<json> {
            json trackJson = body["track"];
            if trackJson is map<json> {
                json t = trackJson["title"];
                if t is string {
                    title = t;
                }
            }
        }
        Track track = {...mockTrack};
        track.urn = trackUrn;
        track.title = title;
        return track;
    }
}


// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ErrorBadRequest record {|
    *http:BadRequest;
    Error body;
|};

public type ErrorNotFound record {|
    *http:NotFound;
    Error body;
|};

public type ErrorUnauthorized record {|
    *http:Unauthorized;
    Error body;
|};

public type ErrorUnprocessableEntity record {|
    *http:UnprocessableEntity;
    Error body;
|};

public type JsonOk record {|
    *http:Ok;
    json body;
|};

public type TooManyRequestsTooManyRequests record {|
    *http:TooManyRequests;
    TooManyRequests body;
|};

public type UserCreated record {|
    *http:Created;
    User body;
|};

public type Error record {
    int code?;
    string link?;
    string message?;
    @deprecated
    string? 'error?;
    @deprecated
    ErrorErrors[] errors?;
    @deprecated
    string status?;
};

public type TooManyRequests record {
    *Error;
    @jsondata:Name {value: "spam_warning_urn"}
    string spamWarningUrn?;
};

public type ErrorErrors record {
    @jsondata:Name {value: "error_message"}
    string errorMessage?;
};
