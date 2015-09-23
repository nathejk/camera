docker:
	docker build -t nathejk/camera .

start:
	docker run -d -P nathejk/camera
