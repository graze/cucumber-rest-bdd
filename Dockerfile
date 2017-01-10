FROM ruby

MAINTAINER "Harry Bragg <harry.bragg@graze.com>"
LABEL version="0.3.5" \
      license="MIT"

RUN gem install cucumber-rest-bdd

WORKDIR /opt/src

ENV field_separator=_
ENV field_camel=false
ENV resource_single=false
ENV cucumber_api_verbose=false
ENV data_key=

CMD ["cucumber"]
