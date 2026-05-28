FROM ruby:3.3-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

RUN mkdir -p tmp/pids && chmod -R 777 tmp

EXPOSE 3000
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && rails db:migrate 2>/dev/null || rails db:setup && rails server -b 0.0.0.0"]