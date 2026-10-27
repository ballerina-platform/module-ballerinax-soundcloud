# Ballerina SoundCloud connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-soundcloud/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-soundcloud/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-soundcloud.svg)](https://github.com/ballerina-platform/module-ballerinax-soundcloud/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/soundcloud.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fsoundcloud)

## Overview

[SoundCloud](https://soundcloud.com) is an online audio platform where artists and listeners share, discover and discuss music and other audio.

The SoundCloud connector lets Ballerina applications call the SoundCloud Public API (version `1.0.0`) to search and manage tracks, playlists and users, read and post comments, and like, repost and follow content on behalf of an authenticated user.

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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`soundcloud` package](https://central.ballerina.io/ballerinax/soundcloud/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
