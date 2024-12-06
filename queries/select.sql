SELECT * FROM tenant WHERE name = ?
SELECT * FROM player WHERE id = ?
SELECT * FROM competition WHERE id = ?
SELECT player_id, MIN(created_at) AS min_created_at FROM visit_history WHERE tenant_id = ? AND competition_id = ? GROUP BY player_id
SELECT DISTINCT(player_id) FROM player_score WHERE tenant_id = ? AND competition_id = ?
SELECT * FROM tenant ORDER BY id DESC
SELECT * FROM competition WHERE tenant_id=?
SELECT * FROM player WHERE tenant_id=? ORDER BY created_at DESC
SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC
SELECT * FROM competition WHERE tenant_id = ? ORDER BY created_at ASC
SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? AND player_id = ? ORDER BY row_num DESC LIMIT 1
SELECT * FROM tenant WHERE id = ?
SELECT * FROM player_score WHERE tenant_id = ? AND competition_id = ? ORDER BY row_num DESC
SELECT * FROM competition WHERE tenant_id=? ORDER BY created_at DESC

----------------------------------------- back quote queries -----------------------------------------
