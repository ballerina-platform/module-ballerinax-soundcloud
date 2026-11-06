# Examples

The `ballerinax/soundcloud` connector provides practical examples illustrating usage in various scenarios.

1. [Genre playlist builder](./genre_playlist_builder/genre_playlist_builder.md) - Search tracks of a genre, collect them into a new playlist and read the playlist back.
2. [Track engagement workflow](./track_engagement_workflow/track_engagement_workflow.md) - Review a track's likes and comments, then like and comment on it.

## Prerequisites

1. A SoundCloud application with a client ID and client secret, and an access token for it, from [SoundCloud for Developers](https://soundcloud.com/you/apps).

2. A `Config.toml` file in the example directory with the values described in the example's documentation.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
