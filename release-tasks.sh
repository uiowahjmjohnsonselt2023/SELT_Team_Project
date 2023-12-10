# Release phase script -- executed by Heroku during release phase
bundle exec rails db:migrate
bundle exec rails assets:precompile

bundle exec rails db:seed
# check for a good exit
if [ $? -ne 0 ]
then
    echo "release_phase.sh failed"
    exit 1
fi