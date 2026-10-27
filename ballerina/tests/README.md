# Running Tests

## Prerequisites

To run the tests against the live service you need a SoundCloud access token and the URNs of an existing track, user and playlist. Set them as environment variables:

```bash
export SOUNDCLOUD_ACCESS_TOKEN="<access-token>"
export SOUNDCLOUD_TRACK_URN="<track-urn>"
export SOUNDCLOUD_USER_URN="<user-urn>"
export SOUNDCLOUD_PLAYLIST_URN="<playlist-urn>"
```

## Running the tests

The tests run against a local mock server by default:

```bash
bal test
```

To run them against the live SoundCloud API, set `IS_LIVE_SERVER`:

```bash
IS_LIVE_SERVER=true bal test
```

Tests that create, change or delete data are skipped against the live server.

## Test coverage

The suite covers 25 operations: reading the authenticated user, searching and reading tracks, playlists and users, listing followings, followers, tracks, comments and favoriters, creating, updating and deleting playlists, updating tracks and creating comments, and liking, unliking, following and unfollowing. Each test is in the `mock_tests` and `live_tests` groups.
