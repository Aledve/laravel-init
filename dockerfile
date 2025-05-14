# Usa PHP 8.1 con Apache
FROM php:8.1-apache

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    zip unzip git curl libzip-dev libonig-dev libpq-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Habilita mod_rewrite de Apache para Laravel
RUN a2enmod rewrite

# Copia los archivos del proyecto al contenedor
COPY . /var/www/html/

# Establece el directorio de trabajo
WORKDIR /var/www/html/

# Da permisos a las carpetas de Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Instala Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instala dependencias de Laravel
RUN composer install --optimize-autoloader --no-dev

# Expone el puerto 80 para HTTP
EXPOSE 80
