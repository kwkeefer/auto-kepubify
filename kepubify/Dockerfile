FROM golang:bookworm

RUN <<EOF
apt-get update

apt-get install inotify-tools -y
EOF

RUN useradd -ms /bin/bash go

USER go
RUN go install github.com/pgaskin/kepubify@latest

WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh

ENTRYPOINT ["bash", "/app/entrypoint.sh"]
