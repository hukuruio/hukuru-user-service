[![Build Status](https://cloud.drone.io/api/badges/hukuruio/hukuru-user-service/status.svg)](https://cloud.drone.io/hukuruio/hukuru-user-service)


# Development

To mount the .src directory into the users container.

Create file called *docker-compose.override.yml* with contents below.

```
version: '3.7'

services:
  users:
    volumes:
      - ./src:/opt/src/app
```
