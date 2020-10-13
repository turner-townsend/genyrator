
deps:
	pip install -r requirements/development.txt

lint: pycodestyle flake8 mypy

pycodestyle:
	pycodestyle .

flake8:
	flake8

mypy:
	mypy genyrator

test: bookshop-build mamba behave

behave:
	behave --tags=-skip test/e2e 

mamba:
	mamba test

pep8:
	pycodestyle genyrator

bookshop-build:
	python bookshop.py


deploy: deploy-clean deploy-build deploy-deploy


deploy-clean:
	rm -rf build/ dist/ genyrator.egg-info/

deploy-build:
	python setup.py sdist bdist_wheel

deploy-deploy:
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*

.PHONY: deps test behave pep8 bookshop-build
