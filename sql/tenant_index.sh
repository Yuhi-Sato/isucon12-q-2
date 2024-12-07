#!/bin/bash

# ターゲットディレクトリを指定（デフォルト: /home/isucon/initial_data）
TARGET_DIR=${1:-/home/isucon/initial_data}

# インデックスを貼るSQL
CREATE_INDEX_SQL="
CREATE INDEX idx_tenant_id_player_id_competition_id ON player_score(tenant_id, player_id, competition_id);
CREATE INDEX idx_score_desc_row_num ON player_score(score DESC, row_num);
"

# ディレクトリ内の*.dbファイルを順に処理
for db_file in "$TARGET_DIR"/*.db; do
    if [ -f "$db_file" ]; then
        echo "Processing $db_file"
        
        # SQLiteコマンドでインデックスを貼る
        sqlite3 "$db_file" <<EOF
$CREATE_INDEX_SQL
EOF

        if [ $? -eq 0 ]; then
            echo "Indexes created successfully for $db_file"
        else
            echo "Failed to create indexes for $db_file"
        fi
    else
        echo "No .db files found in $TARGET_DIR"
    fi
done
