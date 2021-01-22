APPS = admin-frontend auth-frontend internal-api user-frontend

.PHONY: all migrate $(APPS)

all: $(APPS) migrate

migrate:
	docker-compose run internal-api sh -c "bin/rails db:migrate || bin/rails db:setup"
	docker-compose run internal-api env RAILS_ENV=test sh -c "bin/rails db:migrate || bin/rails db:setup"
	docker-compose run internal-api sh -c 'echo "create database hydra;" | psql $$DATABASE_URL'
	docker-compose run hydra-admin migrate sql $(shell grep DSN docker-compose.yml | head -n1 | sed "s/.*: //") -y

$(APPS):
	docker-compose build $@
	docker-compose run $@ rbenv install -s
	docker-compose run $@ bundle
