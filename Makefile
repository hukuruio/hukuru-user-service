default: build test
.PHONY: build test

build:
	 docker-compose up -d --build 

test: 
	docker-compose exec -T users pipenv run python -m pytest -p no:warnings --color=yes ${ARGS} "project/tests"

create_db:
	docker-compose exec -T users pipenv run python manage.py recreate_db
	docker-compose exec -T users pipenv run python manage.py seed_db

stop:
	docker-compose down

cleanup:
	docker-compose down -v -rmi --all
