FROM ruby:3.1.2-slim
ENV BUNDLE_WITHOUT=test:development
RUN apt update && apt install build-essential -y --no-install-recommends
WORKDIR /usr/src/app/
ADD . /usr/src/app/
RUN bundle install \
  && chmod +x bin/fetch_site
ENTRYPOINT ["bin/fetch_site"]
