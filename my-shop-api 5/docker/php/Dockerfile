FROM php:8.0.3-fpm-alpine
RUN apk --update --no-cache add git
RUN docker-php-ext-install pdo_mysql
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /var/www
RUN composer --version && composer self-update 2.2.20
CMD composer install ;  php-fpm
EXPOSE 9000