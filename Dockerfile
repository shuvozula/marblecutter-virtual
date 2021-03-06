FROM andrejreznik/python-gdal:stable
LABEL maintainer="Seth Fitzsimmons <seth@mojodna.net>"

ARG http_proxy

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV GDAL_CACHEMAX 512
ENV GDAL_DISABLE_READDIR_ON_OPEN TRUE
ENV GDAL_HTTP_MERGE_CONSECUTIVE_RANGES YES
ENV VSI_CACHE TRUE
# tune this according to how much memory is available
ENV VSI_CACHE_SIZE 536870912
# override this accordingly; should be 2-4x $(nproc)
ENV WEB_CONCURRENCY 4

EXPOSE 8000

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
    build-essential \
    libpcre3 libpcre3-dev \
    ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# links the cert file where its being expected
RUN mkdir -p /etc/pki/tls/certs/ && \
    ln -s /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt

WORKDIR /opt/marblecutter

COPY requirements-server.txt /opt/marblecutter/
COPY requirements.txt /opt/marblecutter/

RUN pip3 install -U numpy && \
  pip3 install -r requirements-server.txt && \
  rm -rf /root/.cache

COPY . /opt/marblecutter

USER nobody

ENTRYPOINT ["uwsgi", "uwsgi.ini"]
