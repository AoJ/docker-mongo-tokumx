

NAME=aooj/mongo-tokumx
VERSION=1.0


build:
	docker build -t $(NAME):$(VERSION) .

run:
	docker run -ti -p 27017:27017 --name mongo-tokumx --hostname mongo-tokumx -d $(NAME):$(VERSION)

shell:
	docker run -it --rm --link mongo-tokumx:mongo-tokumx $(NAME):$(VERSION) bash -c 'mongo --host mongo-tokumx'

debug: build
	docker run -ti --rm -p 27017 --hostname mongodb $(NAME):$(VERSION) /bin/bash	
