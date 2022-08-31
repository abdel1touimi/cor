start: ## Starts the containers
	docker-compose up -d

build: ## Builds the containers
	docker-compose build

stop: ## Stops the containers
	docker-compose stop

drop:stop  ## Remove the containers
	docker-compose rm

restart: stop start ## Restart containers
