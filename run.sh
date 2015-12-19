#!/bin/bash

function progress {
    echo "$(tput bold)$(tput setaf 4)==>$(tput sgr0) $(tput bold)$1$(tput sgr0)"
}

set -e

progress "Updating submodules…"
cd srweb
git submodule update --init
cd ..

if [ "$(uname -s)" = "Darwin" ]; then
    hash brew >/dev/null 2>&1 || {
        progress "Installing Homebrew…"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    }

    brew tap | grep 'homebrew/bundle' >/dev/null 2>&1 || {
        brew tap Homebrew/bundle
    }

    progress "Installing Homebrew dependencies…"
    brew bundle
elif hash apt-get >/dev/null 2>&1; then
    dpkg -s nginx php5 php5-cli php5-fpm >/dev/null 2>&1 || {
        progress "Installing dependencies…"
        sudo apt-get install -y nginx php5 php5-cli php5-fpm
    }

    sudo chown -R www-data:www-data templates_compiled
else
    echo "WARNING!"
    echo "Unsupported platform. Make sure Nginx and PHP are installed."
fi

if [ ! -f composer.phar ]; then
    progress "Installing Composer…"
    curl -sS https://getcomposer.org/installer | php
fi

progress "Running Composer…"
php composer.phar install

cat << EOF > srweb/local.config.inc.php
<?php

/* srweb doesn't officially use Composer */
// require __DIR__ . '/vendor/autoload.php';

define('SMARTY_DIR', __DIR__ . '/../vendor/smarty/smarty/libs/');

/* some platforms require this */
date_default_timezone_set("Europe/London");

?>
EOF

if hash apt-get >/dev/null 2>&1; then
    echo "Now modify /etc/php5/fpm/pool.d/www.conf to listen on 127.0.0.1:9000."
    echo "And then run: sudo service php5-fpm restart"
    echo
    echo "If you are running Chrome OS, edit script/server to run nginx as sudo"
    sleep 1s
fi

nginx -p $(pwd) -c nginx.conf
