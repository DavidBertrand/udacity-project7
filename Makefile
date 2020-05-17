setup:
	python3 -m venv venv

install:
	python3 -m venv venv
	. venv/bin/activate
	pip install --upgrade pip &&\
	pip install -r requirements.txt

test:
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb

lint:
	hadolint Dockerfile
	pylint --disable=R,C,W1203 app/**.py

all: install lint test