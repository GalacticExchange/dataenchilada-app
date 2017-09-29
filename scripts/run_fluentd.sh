#!/bin/bash
export PATH=/usr/local/rvm/gems/ruby-2.3.3/wrappers:$PATH;
cd /var/www/apps/data_enchilada
bundle exec fluentd -c $1

