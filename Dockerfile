FROM ruby:2.6.10

ENV LANG=C.UTF-8 \
    BUNDLE_PATH=/bundle \
    GEM_HOME=/bundle \
    PATH=/bundle/bin:$PATH

RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    nodejs \
    npm \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN gem install fastlane -v 2.222.0 \
      && gem install bundler -v 2.5.11


# Set up working directory
WORKDIR /

# Copy the Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Install Firebase App Distribution plugin
RUN fastlane add_plugin firebase_app_distribution

# Copy the rest of the application code
COPY . .

# Set up node_modules and Android dependencies
RUN npm install --save-dev jetifier \
    && npx jetifier \
    && npm install

# Default command
CMD ["fastlane", "android", "createApk"]
