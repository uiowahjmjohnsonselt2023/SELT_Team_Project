FROM ruby:2.6.6

WORKDIR /app

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    nodejs

COPY Gemfile Gemfile.lock ./

RUN gem install bundler --no-document -v 1.17.3 && \
    bundle install --jobs 4

COPY . .

EXPOSE 3000
