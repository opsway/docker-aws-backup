FROM ruby:2.4-alpine3.6
RUN apk add --no-cache --virtual .tmp-deps g++ make libgcrypt-dev libxml2 libxslt libxslt-dev libxml2-dev zlib-dev \
  && gem install --no-document nokogiri -v 1.6.8 -- --use-system-libraries --with-xml2-config=/usr/local/bin/xml2-config --with-xslt-config=/usr/local/bin/xslt-config \ 
  && gem install aws-sdk-v1 \
  && apk del .tmp-deps \
  && rm -rf /var/cache/apk/*
WORKDIR /app
ADD . .
RUN chmod +x aws_backup.rb
ENTRYPOINT ["/app/aws_backup.rb"]
CMD ["--help"]
