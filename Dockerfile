FROM ruby:3.0.0

# Install system dependencies and node.js for asset compilation
RUN apt-get update -qq && apt-get install -y postgresql-client

# Install Node.js 14.x
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Set the working directory in the container
WORKDIR /app

# Install required gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the application code into the container
COPY . .

# Set environment variables
ENV RAILS_ENV=development
ENV RAILS_SERVE_STATIC_FILES=true

# Install JavaScript dependencies
RUN yarn install

# Precompile assets
RUN bundle exec rails assets:precompile

# Set up the database
CMD ["rails", "server", "-b", "0.0.0.0"]

