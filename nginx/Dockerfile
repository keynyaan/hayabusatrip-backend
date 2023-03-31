# Nginxのバージョンは軽量版の「alpine」
FROM nginx:alpine

# インクルード用のディレクトリ内を削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
ADD ./nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

# ビルド完了後にNginxを起動
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf