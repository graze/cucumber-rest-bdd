FROM ruby

MAINTAINER "Harry Bragg <harry.bragg@graze.com>"
LABEL version="0.1" \
      license="MIT"

RUN gem install cucumber cucumber-api activesupport

COPY . /usr/local/cucumber-rest-bdd
WORKDIR /usr/local/cucumber-rest-bdd

RUN gem build cucumber-rest-bdd.gemspec \
    && gem install cucumber-rest-bdd-*.gem \
    && rm -rf /usr/local/cucumber-rest-bdd

WORKDIR /opt/src
