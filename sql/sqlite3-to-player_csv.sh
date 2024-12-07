#!/bin/bash

# データベースファイルがあるディレクトリ
TARGET_DIR=${1:-/home/isucon/initial_data}
OUTPUT_DIR=${2:-/var/lib/mysql-files/}

# CSV出力ディレクトリを作成（存在しない場合）
if [ ! -d "$OUTPUT_DIR" ]; then
  echo "Creating output directory: $OUTPUT_DIR"
  mkdir -p "$OUTPUT_DIR"
fi

OUTPUT_FILE=${3:-$OUTPUT_DIR/player.csv}

# 出力ファイルを初期化（既存のファイルを削除）
> "$OUTPUT_FILE"

# ヘッダーを書き込むフラグ
HEADER_WRITTEN=false

# ディレクトリ内の *.db ファイルを処理
for DB_FILE in "$TARGET_DIR"/*.db; do
  if [ -f "$DB_FILE" ]; then
    echo "Processing $DB_FILE..."

    # SQLite コマンドでテーブルのデータを取得
    sqlite3 "$DB_FILE" <<EOF > temp_output.csv
.headers on
.mode csv
SELECT * FROM player;
EOF

    # ヘッダーを一度だけ追加
    if [ "$HEADER_WRITTEN" = false ]; then
      cat temp_output.csv >> "$OUTPUT_FILE"
      HEADER_WRITTEN=true
    else
      # ヘッダーを除外してデータのみ追加
      tail -n +2 temp_output.csv >> "$OUTPUT_FILE"
    fi
  else
    echo "No .db files found in $TARGET_DIR."
  fi
done

# 一時ファイルを削除
rm -f temp_output.csv

echo "All data has been combined into $OUTPUT_FILE."
