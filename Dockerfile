FROM ruby:2.5-alpine as build

COPY . /build
WORKDIR /build

RUN set +xe \
    && apk add --no-cache --virtual .ruby-builddeps \
    autoconf \
    bison \
    bzip2 \
    bzip2-dev \
    ca-certificates \
    coreutils \
    dpkg-dev dpkg \
    gcc \
    g++ \
    gdbm-dev \
    glib-dev \
    libc-dev \
    libffi-dev \
    libressl \
    libressl-dev \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    make \
    ncurses-dev \
    procps \
    readline-dev \
    ruby \
    tar \
    xz \
    yaml-dev \
    zlib-dev \
    && gem build cucumber-rest-bdd.gemspec \
    && gem install cucumber-rest-bdd-*.gem \
    && apk del .ruby-builddeps

FROM ruby:2.5-alpine as app

COPY --from=build /usr/local/bundle /usr/local/bundle

WORKDIR /app

ENV field_separator=_ \
    field_camel=false \
    resource_single=false \
    cucumber_api_verbose=false \
    data_key= \
    error_key=error \
    set_parent_id=false

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="cucumber-rest-bdd" \
    org.label-schema.description="behavioural testing for REST apis" \
    org.label-schema.vcs-url="https://github.com/graze/cucumber-rest-bdd" \
    org.label-schema.version="0.6.1" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE \
    maintainer="harry.bragg@graze.com" \
    version="0.6.1" \
    license="MIT"

ENTRYPOINT ["cucumber"]
