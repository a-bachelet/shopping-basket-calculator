FROM mcr.microsoft.com/devcontainers/ruby

RUN gem install rspec

CMD ["bash", "-c", "sleep infinity"]