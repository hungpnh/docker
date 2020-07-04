FROM php:7.2.25-apache
# Install dependencies including smtp
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN apt-get update \
    && apt-get install -y \
    git \
    python \
    vim \
    expect \
    libpng-dev \
    libjpeg-dev \
    libicu-dev \
    libzip-dev \
    libapache2-mod-xsendfile \
    ssh-client \
    iproute2 \
    zip \
    sshpass \
    nkf;

RUN apt-get update && \
    apt-get install -y \
        libc-client-dev libkrb5-dev && \
    rm -r /var/lib/apt/lists/*
    
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install -j$(nproc) imap
    
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install pdo_mysql \
    mysqli \
    mbstring \
    zip \
    intl \
    exif \
    gd;

RUN a2enmod rewrite;
