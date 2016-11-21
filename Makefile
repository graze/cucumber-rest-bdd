TAG := graze/rest-bdd
RUN := docker run --rm -it -v $(PWD):/opt/src -w /opt/src ${TAG}

build:
	docker build -t ${TAG} .

test:
	${RUN} cucumber --order random
