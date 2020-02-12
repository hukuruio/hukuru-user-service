default: build test
.PHONY: build test

build:
	docker-compose -f docker-compose.yml down
	docker-compose -f docker-compose-dev.yml up -d --build 

test:
	docker-compose -f docker-compose-dev.yml exec -T users pipenv install --dev --skip-lock
	docker-compose -f docker-compose-dev.yml exec -T users pipenv run python -m pytest

create_db:
	docker-compose -f docker-compose-dev.yml exec -T users pipenv run python manage.py recreate_db
	docker-compose -f docker-compose-dev.yml exec -T users pipenv run python manage.py seed_db

stop:
	docker-compose -f docker-compose-dev.yml down
	docker-compose -f docker-compose.yml down 

lock:
	docker-compose -f docker-compose-dev.yml up -d
	docker-compose -f docker-compose-dev.yml exec -T users pipenv lock 
	docker-compose -f docker-compose-dev.yml exec -T users pipenv lock -r > requirements.txt
	echo gunicorn==20.0.4 >> requirements.txt

release:
	docker-compose -f docker-compose-dev.yml down
	docker-compose -f docker-compose.yml up -d --build

cleanup:
	docker-compose -f docker-compose-dev.yml down --rmi all -v
	docker-compose -f docker-compose.yml down --rmi all -v
