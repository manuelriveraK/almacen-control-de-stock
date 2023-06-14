FROM php:8.1.10-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Configurar extensiones PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Habilitar mod_rewrite de Apache
RUN a2enmod rewrite

# Configurar el directorio de trabajo
WORKDIR /var/www/html/backend

# Copiar los archivos del proyecto Laravel al contenedor
COPY . .

# Instalar dependencias de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar dependencias de Laravel
RUN composer install

# Generar la clave de la aplicación
RUN php artisan key:generate

# Establecer permisos en las carpetas de almacenamiento de Laravel
RUN chown -R www-data:www-data /var/www/html/backend/storage

# Exponer el puerto 80
EXPOSE 80

# Comando de inicio del contenedor
CMD ["apache2-foreground"]
