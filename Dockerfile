# Dockerfile
FROM --platform=linux/arm64 dunglas/frankenphp:latest-php8.2

WORKDIR /app

# Install dependencies
RUN apt update && apt install -y \
    libzip-dev \
    unzip \
    && docker-php-ext-install zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Slim Framework

COPY ./composer.json /app
COPY ./composer.lock /app
RUN composer install

RUN install-php-extensions \
	pdo_mysql \
	gd \
	intl \
	zip \
	opcache \
  apcu \
  curl \
  mbstring \
  xml \
  imagick \
  mysqli \
  xdebug

# Copy application files
COPY ./Caddyfile /etc/caddy/Caddyfile


# Expose port
# EXPOSE 80

# Start the application
# CMD ["frankenphp", "-S", "0.0.0.0:80", "-t", "public"]