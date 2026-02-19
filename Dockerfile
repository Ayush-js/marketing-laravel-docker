# ================================
# Stage 1: BUILD STAGE
# ================================
FROM php:8.2-fpm-alpine AS builder

# Install system dependencies including oniguruma for mbstring
RUN apk add --no-cache \
    curl \
    libpng-dev \
    libxml2-dev \
    oniguruma-dev \
    zip \
    unzip \
    git \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    xml

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy composer files first (for caching)
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --no-dev \
    --prefer-dist

# Copy all project files
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage


# ================================
# Stage 2: PRODUCTION STAGE
# ================================
FROM php:8.2-fpm-alpine AS production

# Install only runtime dependencies including oniguruma
RUN apk add --no-cache \
    libpng-dev \
    libxml2-dev \
    oniguruma-dev

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    bcmath \
    gd \
    xml

# Create non-root user for security
RUN addgroup -g 1000 -S www && \
    adduser -u 1000 -S www -G www

# Set working directory
WORKDIR /var/www

# Copy built files from builder stage
COPY --from=builder --chown=www:www /var/www .

# Switch to non-root user
USER www

# Expose port
EXPOSE 9000

CMD ["php-fpm"]
