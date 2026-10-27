## Overview

[SoundCloud](https://soundcloud.com) is an online audio platform where artists and listeners share, discover and discuss music and other audio.

The SoundCloud connector lets Ballerina applications call the SoundCloud Public API (version `1.0.0`) to search and manage tracks, playlists and users, read and post comments, and like, repost and follow content on behalf of an authenticated user.

### Key features

- Search tracks, playlists and users, and read their details
- Upload tracks and create or update playlists
- Read and post comments on tracks
- Like, repost and follow tracks, playlists and users
- Authenticate with OAuth 2.1 (client credentials, authorization code) or an access token

## Setup guide

To use the SoundCloud connector, you need an access token for the SoundCloud API.

1. Sign in to SoundCloud and register an application on the [SoundCloud for Developers](https://soundcloud.com/you/apps) page.

2. Copy the **Client ID** and **Client Secret** of the application.

3. Set the redirect URL of the application if you plan to use the authorization code flow.

4. Keep the credentials safe and supply them to the connector through your `Config.toml` file. The connector requests tokens from `https://secure.soundcloud.com/oauth/token` by default.

## Quickstart

To use the `soundcloud` connector in your Ballerina application, update the `.bal` file as follows:

1. Import the `soundcloud` module.

    ```ballerina
    import ballerinax/soundcloud;
    ```

2. Add the application credentials to the `Config.toml` file.

    ```toml
    clientId = "<CLIENT_ID>"
    clientSecret = "<CLIENT_SECRET>"
    ```

3. Create a `soundcloud:Client` with the client credentials grant.

    ```ballerina
    configurable string clientId = ?;
    configurable string clientSecret = ?;

    soundcloud:Client soundcloudClient = check new ({auth: {clientId, clientSecret}});
    ```

4. Search for tracks.

    ```ballerina
    public function main() returns error? {
        soundcloud:TracksResult _ = check soundcloudClient->searchTracks(q = "synthwave", linkedPartitioning = true);
    }
    ```

## Examples

The `SoundCloud` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-soundcloud/tree/main/examples/), covering the following use cases:

1. [Genre playlist builder](https://github.com/ballerina-platform/module-ballerinax-soundcloud/tree/main/examples/genre_playlist_builder) - Search tracks of a genre, collect them into a new playlist and read the playlist back.
2. [Track engagement workflow](https://github.com/ballerina-platform/module-ballerinax-soundcloud/tree/main/examples/track_engagement_workflow) - Review a track's likes and comments, then like and comment on it.
