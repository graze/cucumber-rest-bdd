FROM ruby:2.5-alpine

RUN set +xe \
    && apk add -u --no-cache \
    bash \
    su-exec \
    ca-certificates \
    tini

RUN set +xe \
    && apk add --no-cache --virtual .ruby-builddeps \
    autoconf \
    bison \
    bzip2 \
    bzip2-dev \
    coreutils \
    dpkg \
    dpkg-dev \
    gcc \
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
    && gem install rubocop \
    && apk del .ruby-builddeps

ENTRYPOINT ["rubocop"]
