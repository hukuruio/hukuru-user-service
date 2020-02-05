default: build test
.PHONY: build test

build:
	 docker-compose up -d --build 

test: 
	docker ps
	docker-compose exec -T users pipenv install --dev
	docker-compose exec -T users pipenv run python -m pytest -p no:warnings --color=yes ${ARGS} "project/tests"

create_db:
	docker-compose exec -T users pipenv run python manage.py recreate_db
	docker-compose exec -T users pipenv run python manage.py seed_db

stop:
	docker-compose down 

lock: build
	docker-compose exec -T users pipenv lock

cleanup:
	docker-compose down --rmi all -v
