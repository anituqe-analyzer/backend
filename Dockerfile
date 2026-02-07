FROM ruby:3.2

ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=88582ede3eab2fd17bd96a0788de9f7ce4c73ebf93ce43ee002a8fa8ce541a8e

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get update -qq \
    && apt-get install -y nodejs build-essential libsqlite3-dev \
    && npm install -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN mkdir -p storage

EXPOSE 7860

CMD ["bash", "-c", "echo 'RAILS_ENV=' $RAILS_ENV && bundle exec rails db:prepare && bundle exec rails db:seed && bundle exec rails server -b 0.0.0.0 -p 7860"]
