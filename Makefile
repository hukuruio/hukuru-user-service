default: build test
.PHONY: build test

build:
	pip install pipenv
	pipenv install 

test:
	pipenv install --dev
	pipenv run python -m pytest "project/tests"
