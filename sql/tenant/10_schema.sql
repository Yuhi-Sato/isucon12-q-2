DROP TABLE IF EXISTS competition;
DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS player_score;

CREATE TABLE competition (
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  title TEXT NOT NULL,
  finished_at BIGINT NULL,
  created_at BIGINT NOT NULL,
  updated_at BIGINT NOT NULL
);

CREATE TABLE player (
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  display_name TEXT NOT NULL,
  is_disqualified BOOLEAN NOT NULL,
  created_at BIGINT NOT NULL,
  updated_at BIGINT NOT NULL
);


CREATE TABLE player_score (
  id VARCHAR(255) NOT NULL PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  player_id VARCHAR(255) NOT NULL,
  competition_id VARCHAR(255) NOT NULL,
  score BIGINT NOT NULL,
  row_num BIGINT NOT NULL,
  created_at BIGINT NOT NULL,
  updated_at BIGINT NOT NULL
);
CREATE INDEX idx_tenant_id_player_id_competition_id ON player_score(`tenant_id`, `player_id`, `competition_id`);
CREATE INDEX idx_score_desc_row_num ON player_score(`score` DESC, `row_num`);

CREATE TABLE latest_player_score (
  tenant_id BIGINT NOT NULL,
  player_id VARCHAR(255) NOT NULL,
  competition_id VARCHAR(255) NOT NULL,
  score BIGINT NOT NULL,
  created_at BIGINT NOT NULL,
  updated_at BIGINT NOT NULL,
  PRIMARY KEY (tenant_id, player_id, competition_id)
);

-- player_scoreのrow_numが最大のスコアをlatest_player_scoreに保存する
CREATE TRIGGER player_score_after_insert
AFTER INSERT ON player_score
FOR EACH ROW
BEGIN
  INSERT INTO latest_player_score (tenant_id, player_id, competition_id, score, created_at, updated_at)
  VALUES (NEW.tenant_id, NEW.player_id, NEW.competition_id, NEW.score, NEW.created_at, NEW.updated_at)
  ON DUPLICATE KEY UPDATE
  score = NEW.score,
  created_at = NEW.created_at,
  updated_at = NEW.updated_at;
END;

-- player_scoreのrow_numが最大のスコアをlatest_player_scoreに保存する
CREATE TRIGGER player_score_after_update
AFTER UPDATE ON player_score
FOR EACH ROW
BEGIN
  INSERT INTO latest_player_score (tenant_id, player_id, competition_id, score, created_at, updated_at)
  VALUES (NEW.tenant_id, NEW.player_id, NEW.competition_id, NEW.score, NEW.created_at, NEW.updated_at)
  ON DUPLICATE KEY UPDATE
  score = NEW.score,
  created_at = NEW.created_at,
  updated_at = NEW.updated_at;
END;

-- player_scoreのrow_numが最大のスコアをlatest_player_scoreに保存する
CREATE TRIGGER player_score_after_delete
AFTER DELETE ON player_score
FOR EACH ROW
BEGIN
  DELETE FROM latest_player_score
  WHERE tenant_id = OLD.tenant_id
  AND player_id = OLD.player_id
  AND competition_id = OLD.competition_id;
END;