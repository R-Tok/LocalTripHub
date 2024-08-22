# ベースイメージの指定
FROM ruby:3.1

# ENV LANG=ja_JP.UTF-8(一般的な日本語のアプリケーションで推奨されている)
ENV LANG=ja_JP.UTF-8
# コンテナ内のシステム時刻を日本標準時に設定
ENV TZ Asia/Tokyo

# 必要なライブラリのインストール
RUN apt-get update -qq && apt-get install -y nodejs default-mysql-client

# 作業ディレクトリの作成
RUN mkdir /MyApp
WORKDIR /MyApp

# GemfileとGemfile.lockを作業ディレクトリにコピー
COPY Gemfile /MyApp/Gemfile
COPY Gemfile.lock /MyApp/Gemfile.lock

# RubyGems / Bundlerのアップデート
RUN gem update --system
RUN bundle update --bundler

# Bundlerを使用してGemをインストール
RUN bundle install
# アプリケーションのソースコードをコピー
COPY . /MyApp

# デフォルトで `rails server` を実行
CMD ["rails", "server", "-b", "0.0.0.0"]