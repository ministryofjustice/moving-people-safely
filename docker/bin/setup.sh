#!/usr/bin/env sh

# Install updated version of Node.js
curl -sL https://deb.nodesource.com/setup_6.x | bash -
apt-get install -y nodejs

# Add Yarn repo and install package
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
npm install -g yarn
