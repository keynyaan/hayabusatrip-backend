## ビルドステージ
# 2023年3月時点の最新安定版Rubyの軽量版「alpine」
FROM ruby:3.2.2-alpine AS builder
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
# 2023年3月時点の最新版のbundler
ENV BUNDLER_VERSION=2.4.10
RUN apk update && \
    apk upgrade && \
    apk add --virtual build-packs --no-cache \
            alpine-sdk \
            build-base \
            curl-dev \
            mysql-dev \
            tzdata && \
    mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN gem install bundler -v $BUNDLER_VERSION
RUN bundle -v
RUN bundle install --jobs=4
RUN apk del build-packs

## 実行ステージ
# 2023年3月時点の最新安定版Rubyの軽量版「alpine」
FROM ruby:3.2.2-alpine
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
ENV RAILS_ENV=production
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
            bash \
            mysql-dev \
            tzdata && \
    mkdir /backend
WORKDIR /backend
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . /backend
RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids
VOLUME /backend/public
VOLUME /backend/tmp
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3010
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]