FROM  ubuntu:20.04
LABEL Maintainer="Mauricio Araya"

ENV HUGO_VERSION=0.79.0
ENV PATH="/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV LANGUAGE=en_US
ENV LANG=en_US.UTF-8
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE='true'

RUN export DEBIAN_FRONTEND='noninteractive' APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE='true' \
    && apt-get --yes update && apt-get upgrade -y \
    && apt-get install --yes \
        apt-transport-https \
        curl \
        git \
        gnupg2 \
        openssh-client \
        unzip

RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
COPY files/nodesource.list /etc/apt/sources.list.d/nodesource.list
RUN export DEBIAN_FRONTEND='noninteractive' APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE='true' \
    && apt-get --yes update \
    && apt-get install --yes nodejs \
    && npm install -g gulp-cli


RUN export DEBIAN_FRONTEND='noninteractive' \
    && curl -Ls "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.deb" \
            -o /tmp/hugo.deb \
    && dpkg -i /tmp/hugo.deb

RUN mkdir -p /opt/bin
COPY files/hugo /opt/bin/hugo
RUN chmod 755 /opt/bin/hugo

WORKDIR /tmp
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

RUN useradd -m -d /home/playground \
               -s /bin/bash \
               -c "Hugo Playground" playground \
    && mkdir -p /home/playground/.ssh \
                /home/playground/.config \
                /home/playground/bin \
                /home/playground/workdir \
    && chown -R playground:playground /home/playground

RUN rm -rf /tmp/* \
    && apt-get --yes clean

WORKDIR /home/playground/workdir

EXPOSE 1313
