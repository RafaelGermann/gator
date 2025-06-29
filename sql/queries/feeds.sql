-- name: CreateFeed :one
INSERT INTO feeds (id, name, url, user_id, created_at, updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    $6
)
RETURNING *;

-- name: GetFeeds :many
SELECT f.name, f.url, f.user_id, u.name FROM feeds f
INNER JOIN users u ON u.id = f.user_id;

-- name: GetFeedByUrl :one
SELECT * FROM feeds f
WHERE f.url = $1;

-- name: MarkFeedFetched :one
UPDATE feeds 
SET last_fetched_at = NOW(),
updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: GetNextFeedToFetch :one
SELECT * 
FROM feeds f
ORDER BY last_fetched_at NULLS FIRST
LIMIT 1;