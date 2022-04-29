ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm AS vanilla

# Very convenient PHP extensions installer: https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apt-get update && apt-get install -y \
    git \
    curl \
    bash \
    # Install extensions
    && install-php-extensions \
        intl \
        opcache \
        bcmath \
        mbstring \
        xml \
        pcntl \
        gd \
        imagick \
        pgsql \
        pdo pdo_pgsql \
        mysqli pdo_mysql \
        redis \
        zip

# Setup php-pm
ADD usr/local/etc/php/conf.d/app.ini /usr/local/etc/php/conf.d/app.ini
ADD usr/local/etc/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

# Add docker entrypoint which runs both nginx and php-fpm
ADD opt/docker-entrypoint.bash /opt/

# Install dumb-init, nginx
RUN apt-get install -y dumb-init nginx \
    && mkdir -p /run/nginx \
    && chmod +x /opt/docker-entrypoint.bash

# Setup nginx
ADD etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default
RUN sed -i 's/\# server_tokens/server_tokens/g' /etc/nginx/nginx.conf

# set dumb-init as entrypoint and run both php-fpm and nginx as child process of dumb-init
ENTRYPOINT ["/usr/bin/dumb-init"]

CMD ["--", "/opt/docker-entrypoint.bash"]

FROM vanilla AS composer

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
