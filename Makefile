default: build test
.PHONY: build test

build:
	docker-compose -f docker-compose-prod.yml down
	docker-compose up -d --build 

test:
	docker exec users pipenv run pytest
	docker exec users pipenv run flake8 project
	docker exec users pipenv run black project
	docker exec users /bin/sh -c "pipenv run isort project/*/*.py"

create_db:
	docker-compose exec -T users pipenv run python manage.py recreate_db
	docker-compose exec -T users pipenv run python manage.py seed_db

stop:
	docker-compose down
	docker-compose -f docker-compose-prod.yml down 

lock:
	docker-compose up -d
	docker-compose exec -T users pipenv lock 
	docker-compose exec -T users pipenv lock -r > requirements.txt

release:
	docker-compose down
	docker-compose -f docker-compose-prod.yml up -d --build

cleanup:
	docker-compose down --rmi all -v
	docker-compose -f docker-compose-prod.yml down --rmi all -v
