FROM golang AS builder

RUN git clone --depth=1 https://github.com/rclone/rclone.git
RUN sed -i 's/server := newAuthServer(opt, bindAddress, state, authURL)/server := newAuthServer(opt, "0.0.0.0:53682", state, authURL)/' \
    ./rclone/lib/oauthutil/oauthutil.go


RUN \
    cd rclone && \
    CGO_ENABLED=0 \
    make

RUN useradd -ms /bin/bash rclone

USER rclone

RUN /go/bin/rclone version
