FROM container4armhf/armhf-alpine:3.4

WORKDIR /certbot
ENV PATH /certbot/venv/bin:$PATH

LABEL description="Letsencrypt based on alpine" \
      tags="latest" \
      build_ver="2016052901"

RUN export BUILD_DEPS="git \
                build-base \
                libffi-dev \
                linux-headers \
                openssl-dev \
                py-pip \
                python-dev" \
    && apk add -U dialog \
                python \
                augeas-libs \
                ${BUILD_DEPS} \
    && pip --no-cache-dir install virtualenv \
    && git clone https://github.com/certbot/certbot /certbot/src \
    && /certbot/src/letsencrypt-auto-source/letsencrypt-auto --os-packages-only \
    && virtualenv --no-site-packages -p python2 /certbot/venv \
    && /certbot/venv/bin/pip install \
                -e /certbot/src/acme \
                -e /certbot/src \
                -e /certbot/src/certbot-apache \
                -e /certbot/src/certbot-nginx \
    && apk del ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/*

EXPOSE 80 443
VOLUME /etc/letsencrypt/

ENTRYPOINT ["certbot"]
CMD ["--help"]
