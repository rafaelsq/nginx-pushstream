FROM ubuntu:wily

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
    build-essential \

    # nginx
    libpcre3-dev \
    zlib1g-dev \

    # pushstream
    libssl-dev \

    # utils
    vim \
    wget && \

    # cleaning
    rm -rf /var/lib/apt/list/*

ENV PREFIX /etc/nginx

ENV NGX_VERSION 1.9.9
ENV NGX_PUSH_STREAM_MUDULE_VERSION 0.5.1

WORKDIR /usr/local/src
RUN echo "Get & Install" && \

    wget -qO- http://nginx.org/download/nginx-${NGX_VERSION}.tar.gz | tar xvz -C ./ && \
    wget -qO- --no-check-certificate https://github.com/wandenberg/nginx-push-stream-module/archive/${NGX_PUSH_STREAM_MUDULE_VERSION}.tar.gz | tar xvz -C ./ && \

    cd nginx-${NGX_VERSION} && \

    # compile n install nginx with push-stream
    ./configure \
        --prefix=${PREFIX} \
        --conf-path=/etc/nginx/nginx.conf \
        --sbin-path=/sbin/nginx \

        --add-module=/usr/local/src/nginx-push-stream-module-${NGX_PUSH_STREAM_MUDULE_VERSION}/ && \

    make && make install && \

    # some cleaning
    rm -rf /usr/local/src && \
    rm /etc/nginx/*.default



RUN ln -sf /dev/stdout ${PREFIX}/logs/access.log && \
    ln -sf /dev/stderr ${PREFIX}/logs/error.log

WORKDIR ${PREFIX} 

CMD ["nginx", "-g", "daemon off;"]
