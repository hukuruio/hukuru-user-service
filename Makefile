default: build test
.PHONY: build test

build:
	 docker-compose up -d --build 

test: 
	docker-compose exec -T users pipenv run python -m pytest "project/tests"

create_db:
	docker-compose exec -T users pipenv run python manage.py recreate_db

stop:
	docker-compose down
