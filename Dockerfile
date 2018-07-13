FROM ruby

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="cucumber-rest-bdd" \
    org.label-schema.description="behavioural testing for REST apis" \
    org.label-schema.vcs-url="https://github.com/graze/cucumber-rest-bdd" \
    org.label-schema.version="0.6.0" \
    maintainer="harry.bragg@graze.com" \
    version="0.6.0" \
    license="MIT"

COPY . /usr/local/cucumber-rest-bdd
WORKDIR /usr/local/cucumber-rest-bdd

RUN gem build cucumber-rest-bdd.gemspec \
    && gem install cucumber-rest-bdd-*.gem \
    && rm -rf /usr/local/cucumber-rest-bdd

WORKDIR /opt/src

ENV field_separator=_
ENV field_camel=false
ENV resource_single=false
ENV cucumber_api_verbose=false
ENV data_key=
ENV error_key=error
ENV set_parent_id=false

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.build-date=$BUILD_DATE

CMD ["cucumber"]
