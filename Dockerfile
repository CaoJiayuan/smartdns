FROM alpine AS builder

LABEL maintainer="Ghostry <ghostry.green@gmail.com>"

RUN export URL=https://api.github.com/repos/pymumu/smartdns/releases/latest \
  && export OS="linux" \
  && apk --no-cache --update add curl \
  && cd / \
  && wget --tries=3 $(curl -s $URL | grep browser_download_url | egrep -o 'http.+\.\w+' | grep -i "$(uname -m)" | grep -m 1 -i "$(echo $OS)") \
  && tar zxvf smartdns.*.tar.gz

FROM alpine

COPY --from=builder /smartdns/usr/sbin/smartdns /bin/smartdns

ADD config.conf /etc/smartdns/smartdns.conf
RUN chmod +x /bin/smartdns

WORKDIR /

VOLUME ["/smartdns"]

EXPOSE 53

CMD ["/bin/smartdns", "-f", "-x", "-c", "/etc/smartdns/smartdns.conf"]
