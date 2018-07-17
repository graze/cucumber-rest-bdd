TAG := graze/cucumber-rest-bdd
RUN := docker run --rm -it -v $(PWD):/opt/src -w /opt/src ${TAG}

build:
	docker-compose build runner

lint:
	docker-compose run --rm rubocop --fail-level warning /src

lint-fix:
	docker-compose run --rm rubocop --auto-correct /src

test: start-test-server
	docker-compose run --rm runner --order random --format progress --fail-fast
	make stop-test-server > /dev/null 2>&1 &

start-test-server: stop-test-server
	docker-compose up -d test-server

stop-test-server:
	docker-compose stop test-server
