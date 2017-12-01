FROM ruby:2.4-alpine3.6
RUN gem install aws-sdk-v1
WORKDIR /app
ADD . .
RUN chmod +x aws_backup.rb
ENTRYPOINT ["/app/aws_backup.rb"]
CMD ["--help"]
