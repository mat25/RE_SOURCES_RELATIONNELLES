.PHONY: build run stop backup
build:
	docker compose build
run:
	docker compose up -d
stop:
	docker compose down
backup:
	bash ops/backup/backup.sh --dry-run --extra frontend/dist
