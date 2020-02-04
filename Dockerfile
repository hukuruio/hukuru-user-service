FROM python:3-alpine

# set consul version
ENV CONSUL_VERSION=1.6.2
ENV APP_ROOT=/opt/app
ENV APP_BASE_DIR=${APP_ROOT}/src
ARG APP_USER=tools


# install dependencies
RUN apk update; \
  apk add --virtual build-deps openssl-dev libffi-dev gcc python3-dev musl-dev; \
  apk add postgresql-dev; \
  apk add netcat-openbsd bash ca-certificates curl wget; \
  pip install pipenv; \
  addgroup -g 1000 tools; \
  adduser -D -u 1000 -G ${APP_USER} ${APP_USER}; \
  mkdir -p ${APP_BASE_DIR} ${APP_ROOT}/packages; \
  wget --quiet --output-document=/tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip; \
  unzip /tmp/consul.zip -d ${APP_ROOT}/packages; \
  rm -f /tmp/consul.zip; \
  chmod +x ${APP_ROOT}/packages/consul; \
  chown -R ${APP_USER}:${APP_USER} ${APP_ROOT}

# set environment varibles
USER ${APP_USER}

# update PATH
ENV PATH="PATH=$PATH:${APP_ROOT}/consul/consul"
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# set working directory
WORKDIR ${APP_BASE_DIR}

# add and install requirements
COPY ./Pip* ${APP_BASE_DIR}/

RUN pipenv install; \
  pipenv install --dev

# add start.sh
COPY ./start.sh ${APP_BASE_DIR}/start.sh
COPY ./service_configs/supervisord/dev-supervisord.conf ${APP_ROOT}/supervisord.conf
COPY ./service_configs/consul.d ${APP_ROOT}/consul.d

# add app
COPY . ${APP_BASE_DIR}

ENTRYPOINT [ "pipenv", "run", "python"]
