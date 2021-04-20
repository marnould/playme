FROM php:7.1.9-fpm

ENV NODE_VERSION=6.2.2 \
    SYMFONY_ALLOW_APPDEV=0

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libfontconfig1 \
    libxrender1 \
    libzip-dev

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN "date"

# Install OPCACHE
RUN docker-php-ext-install opcache

# Install GD
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# Install MBSTRING
RUN docker-php-ext-install mbstring

# Install MCRYPT
RUN apt-get install -y libmcrypt-dev \
    && docker-php-ext-install mcrypt

# Install PDO
RUN apt-get install -y libsqlite3-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite

# Install Postgre PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql pgsql

# Install INTL
RUN apt-get install -y libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Install Imagemagick & PHP Imagick ext
RUN apt-get install -y imagemagick libmagickwand-dev --no-install-recommends && apt-get -y install ghostscript
RUN pecl install imagick && docker-php-ext-enable imagick

# Install BCMATH
RUN docker-php-ext-install bcmath

# Install ZIP
RUN docker-php-ext-install zip

# Install COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version

# Install NODEJS
RUN apt-get install build-essential curl -y && \
    curl -L -o /tmp/nodejs.tar.gz https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz && \
    tar xfvz /tmp/nodejs.tar.gz -C /usr/local --strip-components=1 && \
    rm -f /tmp/nodejs.tar.gz

# Install yarn
RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

# user
RUN useradd -ms /bin/bash symfony
USER symfony

WORKDIR /symfony

COPY conf/php-fpm.conf /etc/php-fpm.conf
COPY conf/php.ini /usr/local/etc/php/conf.d/100-php.ini

