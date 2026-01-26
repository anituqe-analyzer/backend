FROM ruby:3.2

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn build-essential libsqlite3-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN mkdir -p storage
RUN bundle exec rake assets:precompile || true

EXPOSE 7860

CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails db:seed && bundle exec rails server -b 0.0.0.0 -p 7860"]
