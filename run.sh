#!/bin/bash

# puma -C config/puma.rb
echo "Rails Server Started in $RAILS_ENV environment"

rake db:migrate 
echo "Database Migrated"
rake db:seed
echo "Database Seeded"
echo "Rails App Ready to use"

