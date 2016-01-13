# PHP-FPM docker image with composer


```ready for laravel and cakePHP frameworks ```



ImageLayers : [![](https://badge.imagelayers.io/camil/php-fpm:latest.svg)](https://imagelayers.io/?images=camil/php-fpm:latest)


## Info

* Based on php:5.6-fpm official Image [php:5.6-fpm](https://hub.docker.com/_/php/)

        

## Build

For example, if you need to install or remove php extensions, edit the Dockerfile and than build-it.

	git clone git@github.com:camilb/docker-php-fpm.git
	cd ./docker-php-fpm
	docker build --rm -t camil/php-fpm .

## Usage

	docker pull camil/php-fpm
	docker run --rm -d camil/php-fpm


