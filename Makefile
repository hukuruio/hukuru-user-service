default: build test
.PHONY: build test

build:
	 docker-compose up -d --build 

test: 
	docker-compose exec users pipenv run python -m pytest "project/tests"
