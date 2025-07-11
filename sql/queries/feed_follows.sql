-- name: CreateFeedFollow :one
WITH inserted_feed_follow AS (
    INSERT INTO feed_follows (id, feed_id, user_id, created_at, updated_at)
    VALUES ($1, $2, $3, $4, $5)
    RETURNING *
)
SELECT
    iff.*,
    f.name AS feed_name,
    u.name AS user_name
FROM inserted_feed_follow iff
INNER JOIN users u ON u.id = iff.user_id
INNER JOIN feeds f ON f.id = iff.feed_id;
--

-- name: GetFeedFollowsForUser :many
SELECT
    ff.*,
    f.name AS feed_name,
    u.name AS user_name
FROM feed_follows ff
INNER JOIN users u ON u.id = ff.user_id
INNER JOIN feeds f ON f.id = ff.feed_id
WHERE ff.user_id = $1;
--

-- name: DeleteFeedFollow :exec
DELETE FROM feed_follows
WHERE user_id = $1
AND feed_id = $2;
--
