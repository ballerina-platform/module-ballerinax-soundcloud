_Author_:  @DimuthuMadushan \
_Created_: 2026/10/26 \
_Updated_: 2026/10/27 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from SoundCloud. 
The OpenAPI specification is obtained from https://github.com/wso2/api-specs/blob/main/openapi/soundcloud/soundcloud/1.0.0/openapi.yaml.
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.


1. Change `MeQuota upload_seconds_left` to nullable
- **Original**: The `upload_seconds_left` field in `MeQuota` was `not nullable`.
- **Updated**: The `upload_seconds_left` field has been updated to be `nullable`.
- **Reason**: The API can return a null value for this field.
<!-- auto-generated -->

2. **`subscriptions` arrays fixed.** On the `User` and `Me` schemas the `subscriptions` property declared `items` as an array with an `anyOf`, which is not a valid array definition. It is now `type: array` with an object `items` schema (`product`, `recurring`). Changed in `docs/spec/openapi.yaml`.

3. **`info.description` rewritten** as a short plain-text summary of the connector, used as the `Client` doc comment. Changed in `docs/spec/openapi.yaml`.

4. **Duplicate operation summaries made distinct.** `GET /me/activities`, `GET /me/activities/all/own`, `GET /me/activities/tracks`, `GET /me/tracks` and `GET /users/{user_urn}/tracks` shared their summaries with another operation, and the summaries of `POST /tracks/{track_urn}/comments` and `POST /sign-out` did not describe the action. Changed in `docs/spec/openapi.yaml`.

5. **Comment request body media type** changed from `application/json; charset=utf-8` to `application/json` on `POST /tracks/{track_urn}/comments`; the generator dropped the operation with the charset parameter. Changed in `docs/spec/openapi.yaml`.

6. **Missing descriptions added** for the `Track.user`, `Playlist.user` and `Playlist.label` properties (wrapped as `allOf` with a `$ref`, and the `label` duplicate `allOf` member removed), the `Activities` properties `collection`, `next_href` and `future_href`, and the `POST /tracks` request body, so `bal build` has no `undocumented field` or `undocumented parameter` warnings. Changed in `docs/spec/openapi.yaml`.

7. **Inline `oneOf` response unions named.** The `Tracks`, `Playlists` and `SystemPlaylists` responses returned an inline `oneOf` of a paginated collection or a plain list, which generated `inline_response_200*` types. They now reference the new component schemas `TracksResult`, `PlaylistsResult` and `SystemPlaylistsResult`. Changed in `docs/spec/openapi.yaml`.

8. **Operation IDs assigned.** The spec has no `operationId`s. They are named `get*`, `list*`, `search*`, `create*`, `update*`, `delete*` and the API's own verbs (for example `GET /me` is `getMe`, `GET /tracks` is `searchTracks`, `POST /tracks` is `uploadTrack`, `PUT /me/followings/{user_urn}` is `followUser`, `POST /likes/tracks/{track_urn}` is `likeTrack`). The mapping is persisted in `docs/spec/ai-mappings.json`.

9. **Schema renames.** `TracksBody` is `UploadTrackFormRequest`, `TracksBody1` is `UploadTrackUrlEncodedRequest`, `PlaylistsBody` is `CreatePlaylistFormRequest`, `TrackUrnCommentsBody` is `CreateTrackCommentRequest`, `TrackstrackUrncommentsComment` is `NewTrackComment`, `UserProduct` is `SubscriptionProduct`, `UserSubscriptions` is `Subscription`, `WebProfilesInner` is `WebProfile` and `Found` is `Redirect` (persisted in `docs/spec/ai-mappings.json`).

10. **Generic success description replaced.** The `200` response of `DELETE /me/followings/{user_urn}` had the bare description `Success` on a typed body; it now reads `The user was unfollowed.`. Changed in `docs/spec/openapi.yaml`.

11. **Deprecated operations removed.** The eight operations marked `deprecated: true` were deleted, along with path items left empty and components only they used: `GET /me/activities`, `GET /me/activities/all/own`, `GET /me/activities/tracks`, `GET /me/followings/{user_urn}`, `GET /me/followers/{follower_urn}`, `GET /users/{user_urn}/favorites`, `GET /users/{user_urn}/followings/{following_urn}` and `DELETE /reposts/tracks/{track_urn}`. Changed in `docs/spec/openapi.yaml`.

12. **Multipart file parts restored in `uploadTrack`.** The generated client converts the payload with `jsondata:toJson` before `createBodyParts`, which turns the `trackAssetData` and `trackArtworkData` file records into plain JSON, so they were sent as text fields without a filename. `ballerina/client.bal` puts the original file records back into the converted payload before building the body parts. This is a hand edit to generated code and must be re-applied after every client regeneration.

## OpenAPI cli command

The edits above are made in `docs/spec/openapi.yaml`, the authoritative spec. The connector generation pipeline flattens and aligns it into `docs/spec/aligned_ballerina_openapi.json` (names persisted in `docs/spec/ai-mappings.json`), which is the input to the command below.

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --license docs/license.txt --client-methods remote
```

