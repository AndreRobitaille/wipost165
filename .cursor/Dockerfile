# Cursor Cloud Agent base image for the public site.
# Ruby is pinned to the version in .ruby-version. Cursor checks out the
# repository after this image is built, so this file does not copy the app.
# The production image at the repository root is separate and is not used here.

FROM ruby:4.0.6-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_APP_CONFIG=/usr/local/bundle \
    GEM_HOME=/usr/local/bundle

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      libffi-dev \
      libssl-dev \
      libyaml-dev \
      pkg-config \
      sudo \
      tzdata \
      zlib1g-dev; \
    rm -rf /var/lib/apt/lists/*; \
    if ! id ubuntu >/dev/null 2>&1; then \
      useradd --create-home --shell /bin/bash --uid 1000 --user-group ubuntu; \
    fi; \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu; \
    chmod 0440 /etc/sudoers.d/ubuntu; \
    mkdir -p /usr/local/bundle; \
    chmod 1777 /usr/local/bundle

USER ubuntu
WORKDIR /home/ubuntu

ENTRYPOINT []
CMD ["bash"]
