FROM ruby:2.6.6-alpine

ENV HOME=/moebooru \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR /moebooru

COPY Gemfile* ./

RUN apk update && \
    apk upgrade

RUN apk add --virtual build-dependencies --no-cache build-base linux-headers postgresql-dev libxml2-dev curl-dev && \
    apk add --no-cache tzdata libpq git imagemagick nodejs yarn && \
    yarn install && \
    gem install bundler -v 2.1.4 && \
    bundle install && \
    apk del build-dependencies --purge

COPY . /moebooru

RUN mkdir -p public/data
RUN cat config/database.yml.example | sed -e 's/127.0.0.1/postgres/' > config/database.yml
RUN cp config/local_config.rb.example config/local_config.rb

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
