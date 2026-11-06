# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- OAuth 2.0 authentication. `ConnectionConfig.auth` accepts an `OAuth2ClientCredentialsGrantConfig`, an `OAuth2RefreshTokenGrantConfig`, an `http:BearerTokenConfig` or an `ApiKeysConfig`.
- Remote methods for the authenticated user: `listMyFeed`, `listMyFeedTracks`, `listMyRecentlyPlayedTracks`, `listMyLikedPlaylists`, `listMyLikedSystemPlaylists`, `listMyTrackReposts` and `listMyPlaylistReposts`.
- Remote methods for tracks: `uploadTrack`, `updateTrack`, `updateTrackStorefront` and `getTrackPreview`.
- Remote methods for other users: `listRelatedUsers`, `listUserLikedPlaylists`, `listUserLikedSystemPlaylists`, `listUserTrackReposts` and `listUserPlaylistReposts`.
- `getSystemPlaylist`, `disconnectApp` and `signOut`.
- The records these methods use, such as `Me`, `SystemPlaylist`, `Storefront`, `StorefrontUpdateRequest`, `UploadTrackFormRequest` and `Subscription`.
- A `*Queries` record for each operation that takes query parameters, such as `SearchTracksQueries` and `ListTrackCommentsQueries`.
- An optional `headers` parameter on every remote method, for sending extra request headers.
- New `ConnectionConfig` fields, taken from `http:ClientConfiguration`: `followRedirects`, `cookieConfig`, `socketConfig` and `laxDataBinding`.

### Changed

- **Breaking:** `init` no longer takes an `ApiKeysConfig` as its first parameter. Credentials go in the required `ConnectionConfig.auth` field:

    ```ballerina
    // 1.5.2
    soundcloud:Client soundcloud = check new ({authorization: "OAuth " + token});
    ```

    ```ballerina
    // 2.0.0
    soundcloud:Client soundcloud = check new ({auth: {authorization: "OAuth " + token}});
    ```

- **Breaking:** these remote methods are renamed:

    | 1.5.2 | 2.0.0 |
    |---|---|
    | `getUserDetail` | `getMe` |
    | `getFollowers` | `listMyFollowers` |
    | `listFollowings` | `listMyFollowings` |
    | `listRecentTracks` | `listMyFollowingsTracks` |
    | `deleteFollowing` | `unfollowUser` |
    | `listLikedTracks` | `listMyLikedTracks` |
    | `listPlaylist` | `listMyPlaylists` |
    | `listTracks` | `listMyTracks` |
    | `searchPlaylist` | `searchPlaylists` |
    | `searchUser` | `searchUsers` |
    | `listReposts` | `listPlaylistReposters` |
    | `getTracksUnderPlaylist` | `listPlaylistTracks` |
    | `deleteRepost` | `removePlaylistRepost` |
    | `repostTrackByTrackID` | `repostTrack` |
    | `resolveSoundCloudURLToResourceURL` | `resolveUrl` |
    | `getTrackByID` | `getTrack` |
    | `getCommentsOnTrack` | `listTrackComments` |
    | `addComment` | `createTrackComment` |
    | `getLikedUsersOfTrack` | `listTrackFavoriters` |
    | `listRelatedTracksOfTrack` | `listRelatedTracks` |
    | `getRepostCollection` | `listTrackReposters` |
    | `getStreambleURL` | `getTrackStreams` |
    | `getUserByID` | `getUser` |
    | `listFollowers` | `listUserFollowers` |
    | `listUserPlaylist` | `listUserPlaylists` |
    | `listUserLinks` | `listUserWebProfiles` |

- **Breaking:** tracks, playlists and users are identified by URN. Path parameters are `string` URNs (`trackUrn`, `playlistUrn`, `userUrn`) instead of `int` IDs (`trackId`, `playlistId`, `userId`), and the `id`, `user_id` and `track_id` fields of `Track`, `Playlist`, `User`, `Comment` and `CommentUser` are replaced by `urn`, `userUrn` and `trackUrn`.
- **Breaking:** query parameters are no longer positional. `q`, `access`, `limit`, `linkedPartitioning`, `secretToken` and the others are passed as named arguments (or as the operation's `*Queries` record), and the `q` of the search methods is optional:

    ```ballerina
    // 1.5.2
    soundcloud:InlineResponse2001 tracks = check soundcloud->searchTracks("lofi", 'limit = 10);
    ```

    ```ballerina
    // 2.0.0
    soundcloud:TracksResult tracks = check soundcloud->searchTracks(q = "lofi", 'limit = 10);
    ```

- **Breaking:** the `ids` query parameter of `searchTracks` is now `urns`.
- **Breaking:** the methods return named types instead of the `InlineResponse*` records. Track lists return `TracksResult`, playlist lists `PlaylistsResult`, user lists `Users`, `listTrackComments` returns `Comments`, `getMe` returns `Me` (was `CompleteUser`), and `createPlaylist` and `updatePlaylist` return `Playlist` (was `InlineResponse201`).
- **Breaking:** `deletePlaylist`, `deleteTrack`, `repostPlaylist`, `repostTrack` and `removePlaylistRepost` return `error?` (was `http:Response|error`).
- **Breaking:** record fields use camel case, mapped to the API's snake-case JSON names with `@jsondata:Name`. For example, `Track.artwork_url` is now `artworkUrl`, `User.followers_count` is now `followersCount`, and `Tracks.next_href` is now `nextHref`.
- **Breaking:** the `TrackDataRequest` fields are camel case (for example `'track\[title\]` is now `trackTitle`), and `trackArtworkData` and `trackAssetData` take a file record with `fileContent` and `fileName` (was `string`).
- **Breaking:** these records are renamed:

    | 1.5.2 | 2.0.0 |
    |---|---|
    | `CreateupdateplaylistrequestPlaylist` | `CreateUpdatePlaylistRequestPlaylist` |
    | `CreateupdateplaylistrequestPlaylistTracks` | `CreateUpdatePlaylistRequestPlaylistTracks` |
    | `TrackmetadatarequestTrack` | `TrackMetadataRequestTrack` |
    | `TrackIdCommentsBody` | `CreateTrackCommentRequest` |
    | `WebprofilesInner` | `WebProfile` |

- **Breaking:** `Track.bpm` is a `decimal` (was `int`), `Track.downloadable` is a `boolean` (was `string`), and `User.subscriptions` is a `Subscription[]` (was `anydata[][]`).
- **Breaking:** `Track.user`, `Playlist.user` and `Playlist.label` are `User` (was the connector's own `MetaUser`).
- **Breaking:** `ConnectionConfig.http1Settings` is now `http:ClientHttp1Settings` (was the connector's own `ClientHttp1Settings`).
- `ConnectionConfig.timeout` defaults to 30 seconds (was 60).

### Removed

- **Breaking:** `getActivities`, `getOwnActivities`, `getRecentTrackRelatedActivities`, `listConnectedSocialAccounts`, `getConnectionByID`, `listUserComments` and `deleteRepostOnTrack`, whose endpoints the API no longer defines. Use `listMyFeed` and `listMyFeedTracks` for the authenticated user's feed.
- **Breaking:** the `CompleteUser`, `CompleteuserQuota`, `Connection`, `Connections`, `CommentsList`, `UsersList`, `UserslistInner`, `MetaUser`, `MetaUsers`, `InlineResponse200`, `InlineResponse2001`, `InlineResponse2002`, `InlineResponse2003`, `InlineResponse201`, `InlineResponse201Tracks`, `TrackstrackIdcommentsComment`, `Found`, `Error` and `TooManyRequests` records.
- **Breaking:** the `User.myspace_name` field, and the `hls_opus_64_url` and `http_mp3_128_url` fields of `Streams`.
- **Breaking:** the connector's own `ClientHttp1Settings` and `ProxyConfig` records. Use `http:ClientHttp1Settings` and `http:ProxyConfig` instead.
