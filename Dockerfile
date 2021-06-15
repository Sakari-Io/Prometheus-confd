FROM golang:1.16
WORKDIR /go/src/github.com/shoenig/bcrypt-tool 
RUN go get gophers.dev/cmds/bcrypt-tool


FROM prom/prometheus

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY confd /etc/confd/
COPY --from=0 /go/bin/bcrypt-tool /bin/

USER root
RUN touch /etc/confd/hashed.yaml
RUN wget -O /bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 && \
      chmod +x /bin/confd && \
      [ "255d2559f3824dd64df059bdc533fd6b697c070db603c76aaf8d1d5e6b0cc334  /bin/confd" = "$(sha256sum /bin/confd)" ] && \
      chmod +x /usr/local/bin/docker-entrypoint.sh && \
      chmod ugo+rwx /etc/confd/hashed.yaml

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
