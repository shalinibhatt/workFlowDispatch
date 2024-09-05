# Use the official Ubuntu image as the base image
FROM ubuntu:20.04

# Set environment variables
ENV LANG=C.UTF-8 \
    BUNDLE_PATH=/bundle \
    GEM_HOME=/bundle \
    PATH=/bundle/bin:$PATH \
    NODE_VERSION=16.17.1 \
    RUBY_VERSION=3.0.5 \
    JAVA_VERSION=17.0.10 \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Kolkata

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    nodejs \
    npm \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*


# Install Ruby 3.0.5 from source
RUN wget https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.5.tar.gz && \
    tar -xzf ruby-3.0.5.tar.gz && \
    cd ruby-3.0.5 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf ruby-3.0.5 ruby-3.0.5.tar.gz

# Install bundler and Fastlane
RUN gem install bundler -v 2.3.14
RUN gem install fastlane -v 2.222.0

# Set up the working directory
WORKDIR /app

# Copy the application code
COPY . .

# Install Ruby dependencies and Fastlane plugin
RUN bundle install && \
    bundle exec fastlane add_plugin firebase_app_distribution

# Run Fastlane to build the APK
CMD ["fastlane", "android", "createApk"]
