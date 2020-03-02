help:
	@cat Makefile

CONTNAME?="rbf9_memTest"

DATA?="/data/usr/rbf9/AERTS"
SRC?="${HOME}/memTest"

DOCKER=NV_GPU=$(GPU) nvidia-docker
GPU?=0

PYTHON_VERS?=3.7
Name?=rbf9
UsrID?=$$(id -u)
GrpID?=$$(id -g)

rfn_FILE= ${HOME}/DockerDepot/raflow_next_DF


build_next:
	$(DOCKER) build -t raflow_next --build-arg USER=$(Name) --build-arg UID=$(UsrID) --build-arg GID=$(GrpID) -f $(rfn_FILE) .

bash: build_next
	$(DOCKER) run -it --rm --name=$(CONTNAME) -u $(UsrID):$(GrpID) -v $(SRC):/src/workspace -v $(DATA):/data raflow_next bash

dbash: build_next
	$(DOCKER) run -it -d --name=$(CONTNAME) -u $(UsrID):$(GrpID) -v $(SRC):/src/workspace -v $(DATA):/data raflow_next bash

