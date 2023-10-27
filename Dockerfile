FROM ruby:3.2-bullseye AS sinatra_bundle

COPY Gemfile /app/Gemfile

WORKDIR /app
RUN bundle install
COPY . /app