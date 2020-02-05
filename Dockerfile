FROM python:3-alpine

ENV APP_ROOT=/opt/src
ENV APP_BASE_DIR=${APP_ROOT}/app
ARG APP_USER=tools


# install dependencies
RUN apk update; \
  apk add --virtual build-deps openssl-dev libffi-dev gcc python3-dev musl-dev; \
  apk add postgresql-dev; \
  apk add netcat-openbsd bash ca-certificates curl wget; \
  pip install pipenv; \
  mkdir -p ${APP_BASE_DIR}; \
  addgroup -g 1000 tools; \
  adduser -D -u 1000 -G ${APP_USER} ${APP_USER}; \
  chown -R ${APP_USER}:${APP_USER} ${APP_ROOT}

# set environment varibles
USER ${APP_USER}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# set working directory
WORKDIR ${APP_BASE_DIR}

# add and install requirements
COPY ./src/Pip* ${APP_BASE_DIR}/

RUN pipenv install --ignore-pipfile

# add start.sh
COPY ./src/start.sh ${APP_ROOT}/start.sh
COPY ./docker/supervisord/dev-supervisord.conf ${APP_ROOT}/supervisord.conf

# add app
COPY ./src ${APP_BASE_DIR}

ENTRYPOINT [ "pipenv", "run", "python"]
