APPS = admin-frontend auth-frontend internal-api user-frontend

.PHONY: all $(APPS)

all: $(APPS)

$(APPS):
	docker-compose build $@
	docker-compose run $@ rbenv install -s
	docker-compose run $@ bundle
