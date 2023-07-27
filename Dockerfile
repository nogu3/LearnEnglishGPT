FROM mcr.microsoft.com/devcontainers/ruby:1-3.2-bullseye

WORKDIR /workspaces/aia

USER vscode

COPY ./Gemfile* .

RUN bundle install
