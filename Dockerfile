FROM mcr.microsoft.com/devcontainers/ruby:1-3.2-bullseye

WORKDIR /workspaces/aia

COPY ./Gemfile* .

RUN bundle install
