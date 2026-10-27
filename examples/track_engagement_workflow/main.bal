// Reviews a track, shows who liked it and what listeners said, then optionally likes and comments on it.

import ballerina/io;
import ballerinax/soundcloud;

configurable string accessToken = ?;
configurable string trackUrn = ?;
configurable string commentText = "Great track!";
configurable boolean engage = false;

public function main() returns error? {
    soundcloud:Client soundcloudClient = check new ({auth: {authorization: "OAuth " + accessToken}});

    // Step 1: Read the track details.
    soundcloud:Track track = check soundcloudClient->getTrack(trackUrn);
    io:println("Track: ", track?.title ?: "(untitled)", " by ", track?.user?.username ?: "unknown artist");
    io:println("Plays: ", track?.playbackCount ?: 0, ", likes: ", track?.favoritingsCount ?: 0);

    // Step 2: List the users who liked the track.
    soundcloud:Users favoriters = check soundcloudClient->listTrackFavoriters(trackUrn, 'limit = 10, linkedPartitioning = true);
    foreach soundcloud:User fan in favoriters?.collection ?: [] {
        io:println("  liked by ", fan?.username ?: "unknown");
    }

    // Step 3: Read the existing comments.
    soundcloud:Comments comments = check soundcloudClient->listTrackComments(trackUrn, 'limit = 10, linkedPartitioning = true);
    foreach soundcloud:Comment existing in comments?.collection ?: [] {
        io:println("  comment: ", existing?.body ?: "");
    }

    // Step 4: Like and comment on the track (side effects, opt in via Config.toml).
    if !engage {
        io:println("Set engage = true in Config.toml to like and comment on the track.");
        return;
    }
    json _ = check soundcloudClient->likeTrack(trackUrn);
    soundcloud:Comment posted = check soundcloudClient->createTrackComment(trackUrn, {comment: {body: commentText}});
    io:println("Liked the track and posted comment ", posted?.urn ?: "");
}
