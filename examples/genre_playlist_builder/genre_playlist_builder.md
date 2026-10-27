# Genre playlist builder

This example searches SoundCloud for tracks of a genre, lists the matches and, when enabled, collects them into a new private playlist and reads the playlist's tracks back.

## Prerequisites

1. A SoundCloud user access token obtained through the authorization code flow, for an application registered on [SoundCloud for Developers](https://soundcloud.com/you/apps). Creating a playlist acts on behalf of a user, so a client credentials token is not enough. Follow the [authorization code steps](https://developers.soundcloud.com/docs/api/guide#authentication) to get one.

2. Create a `Config.toml` file in the example directory with the following values.

```toml
accessToken = "<ACCESS_TOKEN>"
genre = "synthwave"
searchTerm = "night drive"
maxTracks = 5
createPlaylist = false
```

Set `createPlaylist = true` to create the playlist in your account.

## Run the example

```bash
bal run
```
