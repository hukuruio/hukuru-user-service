#!/bin/sh

echo "Waiting for postgres..."

while ! nc -z users-db 5432; do
  sleep 0.1
done

pipenv run supervisord -c ${APP_ROOT}/supervisord.conf
