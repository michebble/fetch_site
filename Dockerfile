FROM alpine:3.18
ENV BUNDLE_WITHOUT=test:development
RUN apk update && \
  apk upgrade && \
  apk add bash curl-dev ruby-dev build-base && \
  apk add ruby=3.2.2-r0 ruby-bundler=2.4.15-r0 && \
  rm -rf /var/cache/apk/*  && \
  apk del bash curl-dev ruby-dev build-base
WORKDIR /usr/src/app/
ADD . /usr/src/app/
RUN bundle install \
  && chmod +x bin/fetch_site
ENTRYPOINT ["bin/fetch_site"]
