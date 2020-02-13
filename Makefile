default: build test
.PHONY: build test

build:
	docker-compose -f docker-compose-prod.yml down
	docker-compose up -d --build 

test:
	docker-compose exec -T users pipenv run pytest
	docker-compose exec -T users pipenv run flake8 project
	docker-compose exec -T users pipenv run black project
	docker-compose exec -T users /bin/sh -c "pipenv run isort project/*/*.py"

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

test_release:
	docker-compose -f docker-compose-prod.yml exec -T users pipenv install --dev
	docker-compose -f docker-compose-prod.yml exec -T users pipenv run pytest
	docker-compose -f docker-compose-prod.yml exec -T users pipenv run flake8 project

cleanup:
	docker-compose down --rmi all -v
	docker-compose -f docker-compose-prod.yml down --rmi all -v
