FROM --platform=linux/arm64 composer:latest AS composer
WORKDIR /app
COPY ./composer.* ./
RUN composer install --ignore-platform-reqs --no-scripts --prefer-dist

FROM --platform=linux/arm64 dunglas/frankenphp:latest-php8.2

WORKDIR /app

# Install dependencies
RUN apt update && apt install -y \
    libzip-dev \
    unzip \
    && docker-php-ext-install zip

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
COPY --from=composer /app/vendor /app/vendor
COPY ./Caddyfile /etc/caddy/Caddyfile


# Expose port
# EXPOSE 80

# Start the application
# CMD ["frankenphp", "-S", "0.0.0.0:80", "-t", "public"]