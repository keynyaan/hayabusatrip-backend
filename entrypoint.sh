#!/bin/bash
set -e

# Rails特有の問題を解決するためのコマンド
rm -f /backend/tmp/pids/server.pid

if [ "$RAILS_ENV" = "production" ]; then
  # 本番環境（AWS ECS）への初回デプロイ時に利用
  # 初回デプロイ後にコメントアウトする
   # bundle exec rails db:create
  # --------------------------------------
  # 2回目以降のデプロイ時に利用
  # 初回デプロイ後にコメントアウトを外す
  bundle exec rails db:migrate
fi

# サーバー実行(DockerfileのCMDをセット)
exec "$@"