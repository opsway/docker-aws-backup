FROM ruby:2.1
RUN gem install aws-sdk-v1
WORKDIR /app
ADD . .
RUN chmod +x aws_backup.rb
ENTRYPOINT ["/app/aws_backup.rb"]
CMD ["--help"]
