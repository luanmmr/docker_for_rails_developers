FROM ruby:2.6-buster

LABEL maintainer="Luan M Ribeiro"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  yarn

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

# Indicates another path where the gems will
# be installed by the bundle
ENV BUNDLE_PATH /gems
RUN bundle install

COPY . /usr/src/app/

# It's necessary to change file permission to:
# chmod +x docker-entrypoint.sh
ENTRYPOINT [ "./docker-entrypoint.sh" ]

CMD ["bin/rails", "s", "-b", "0.0.0.0"]