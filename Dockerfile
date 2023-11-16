# Use the official Ruby base image with a specific version
FROM ruby:3.0.0

# Set the working directory in the container
WORKDIR /app

# Install system dependencies and node.js for asset compilation
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Install required gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy the application code into the container
COPY . .

# Set environment variables
ENV RAILS_ENV=development
ENV RAILS_SERVE_STATIC_FILES=true

# Set up the database
CMD ["rails", "server", "-b", "0.0.0.0"]
