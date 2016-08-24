FROM ruby:2.1
WORKDIR /app
ADD . .
RUN gem install aws-sdk-v1
ENTRYPOINT ["ruby aws_backup.rb"]
CMD ["--help"]
