FROM ruby:2.6.6

# update image and install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    nodejs

# install bundler to the specified version
RUN gem install bundler --no-document -v 1.17.3

# create app directory
WORKDIR /app

# copy Gemfile and install gems
ADD ./Gemfile* ./
RUN bundle install

# copy the rest of the app
COPY . . 

ENV RAILS_ENV=development
RUN bundle exec rake db:drop 
# RUN bundle exec rake db:seed -- NOTE: Cannot run as this point the rails app is not running yet

