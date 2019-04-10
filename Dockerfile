FROM alpine:3.8

RUN apk update
RUN apk add transmission-cli inotify-tools

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod 744 /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
