FROM php:8.1.10-zts-bullseye

# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
# RUN sed -i "s/;zend_extension=opcache/zend_extension=opcache/" "$PHP_INI_DIR/php.ini"
# RUN sed -i "s/;opcache.enable=1/opcache.enable=1/" "$PHP_INI_DIR/php.ini"
# RUN sed -i "s/;opcache.enable_cli=0/opcache.enable_cli=1/" "$PHP_INI_DIR/php.ini"
# RUN sed -i "s/;opcache.huge_code_pages=1/opcache.huge_code_pages=1/" "$PHP_INI_DIR/php.ini"
# RUN echo "opcache.jit_buffer_size=20M" >> "$PHP_INI_DIR/php.ini"
# RUN echo "opcache.jit=tracing" >> "$PHP_INI_DIR/php.ini"

WORKDIR /app

ENV http_proxy http://child-prc.intel.com:911
ENV HTTP_PROXY http://child-prc.intel.com:911
ENV https_proxy http://child-prc.intel.com:911
ENV HTTPS_PROXY http://child-prc.intel.com:912

RUN pear config-set http_proxy http://child-prc.intel.com:911/
RUN apt update && apt install -y protobuf-compiler wget git
RUN pecl install protobuf

RUN wget https://github.com/spiral/php-grpc/releases/download/v1.6.0/protoc-gen-php-grpc-1.6.0-linux-amd64.tar.gz
RUN wget https://github.com/spiral/php-grpc/releases/download/v1.6.0/rr-grpc-1.6.0-linux-amd64.tar.gz
RUN tar -xvf protoc-gen-php-grpc-1.6.0-linux-amd64.tar.gz && cp protoc-gen-php-grpc-1.6.0-linux-amd64/protoc-gen-php-grpc /usr/bin/
RUN tar -xvf rr-grpc-1.6.0-linux-amd64.tar.gz && cp rr-grpc-1.6.0-linux-amd64/rr-grpc /usr/bin/

COPY proto /app/proto
COPY php_grpc_bench/composer.json /app/composer.json

RUN mkdir src && protoc --php_out=src --php-grpc_out=src --proto_path=/app/proto/helloworld helloworld.proto
RUN wget https://getcomposer.org/installer -O composer-setup.php
#RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --quiet
RUN ./composer.phar install

COPY php_grpc_bench /app

ENTRYPOINT [ "rr-grpc", "serve" ]
