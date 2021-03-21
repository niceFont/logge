FROM fluent/fluentd:v1.12-1

ARG AWS_KEY_ID
ARG AWS_SECRET_KEY
ARG S3_BUCKET_NAME
ARG REGION
ENV AWS_KEY_ID=$AWS_KEY_ID
ENV AWS_SECRET_KEY=$AWS_SECRET_KEY
ENV S3_BUCKET_NAME=$S3_BUCKET_NAME
ENV REGION=$REGION
# Use root account to use apk
USER root


# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install fluent-plugin-s3 \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
EXPOSE 24224
EXPOSE 24224/udp

COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/
#Only for testing purposes, will be replaced by IAM permissions later
RUN sed -i -e "s|\[AWS_KEY_ID\]|$AWS_KEY_ID|g" -e "s|\[AWS_SECRET_KEY\]|$AWS_SECRET_KEY|g" -e "s|\[S3_BUCKET_NAME\]|$S3_BUCKET_NAME|g" -e "s|\[REGION\]|$REGION|g" /fluentd/etc/fluent.conf
USER fluent