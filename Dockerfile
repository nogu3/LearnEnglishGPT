FROM mcr.microsoft.com/devcontainers/ruby:1-3.2-bullseye

WORKDIR /workspaces/LearnEnglishGPT

COPY ./Gemfile* .

RUN bundle install
