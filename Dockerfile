FROM ruby:3.2-bullseye AS sinatra_bundle

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev vim

ADD Gemfile Gemfile
ENV BUNDLE_PATH /gem_cache
ENV GEM_PATH /gem_cache
ENV GEM_HOME /gem_cache

RUN gem install bundler
RUN bundle install

ADD . /app