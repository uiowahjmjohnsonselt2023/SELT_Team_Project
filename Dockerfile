FROM --platform=linux/x86_64 ruby:2.6.6 as base

# update image and install dependencies
RUN apt-get update && \
    apt-get install -y pkg-config libxml2-dev libxslt-dev \
    build-essential \
    nodejs

# install bundler to the specified version
RUN gem install bundler --no-document -v 1.17.3

# create app directory
WORKDIR /app

# copy Gemfile and install gems
ADD ./Gemfile* ./
RUN rm -rf vendor/cache
# ensure we're using the correct platform
RUN bundle config force_ruby_platform true   
RUN bundle install

# copy the rest of the app
COPY . . 

RUN bundle exec rake db:migrate

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

EXPOSE 3000
