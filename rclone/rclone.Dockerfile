FROM rclone/rclone

RUN apk add inotify-tools bash

WORKDIR /app

USER rclone

COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["bash", "/app/entrypoint.sh"]