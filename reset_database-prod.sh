#!/bin/bash

set -ex

case "${RAILS_ENV}" in
test)
bundle install
bundle exec rake db:reset_and_migrate
;;
production)
bundle install
bundle exec rake db:create
bundle exec rake db:reset
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake skins:load_site_skins
bundle exec rake search:index_tags
bundle exec rake search:index_works
bundle exec rake search:index_pseuds
bundle exec rake search:index_bookmarks
docker compose run web bundle exec rake db:schema:load
docker compose run web bundle exec rails runner script/ensure_required_tags.rb
docker compose run web bundle exec rake skins:load_site_skins
docker compose up -d web
;;
*)
echo "Only supported in test and development (e.g. 'RAILS_ENV=test ./script/reset_database.sh')"
exit 1
;;
esac
