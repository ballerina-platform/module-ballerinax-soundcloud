# Track engagement workflow

This example reads a track, lists the users who liked it and the comments on it, and, when enabled, likes the track and posts a comment.

## Prerequisites

1. A SoundCloud access token for an application registered on [SoundCloud for Developers](https://soundcloud.com/you/apps). With `engage = true` the example likes and comments on the track as a user, which needs a user token obtained through the authorization code flow with the user's consent. Follow the [authorization code steps](https://developers.soundcloud.com/docs/api/guide#authentication) to get one.

2. Create a `Config.toml` file in the example directory with the following values.

```toml
accessToken = "<ACCESS_TOKEN>"
trackUrn = "<TRACK_URN>"
commentText = "Great track!"
engage = false
```

Set `engage = true` to like the track and post the comment.

## Run the example

```bash
bal run
```
