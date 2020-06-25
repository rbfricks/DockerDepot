help:
	@cat Makefile

CONTNAME?="rbf9_CVX"

SRC?="${HOME}/COVIX"

CHESTX?="/data/usr/rbf9/ChestX"
RSNAP?="/data/usr/rbf9/RSNAP"
COVID?="/data/usr/rbf9/COVID"
Phase2?="/data/usr/rbf9/Phase2"

qualt?="${HOME}/QualityScoreCT"

DOCKER=NV_GPU=$(GPU) nvidia-docker
GPU?=0,1

PYTHON_VERS?=3.7
Name?=rbf9
UsrID?=$$(id -u)
GrpID?=$$(id -g)

rfn_FILE= ${HOME}/DockerDepot/raflow_next_DF


build_next:
	$(DOCKER) build -t raflow_next --build-arg USER=$(Name) --build-arg UID=$(UsrID) --build-arg GID=$(GrpID) -f $(rfn_FILE) .

bash: build_next
	$(DOCKER) run -it --rm --name=$(CONTNAME) -u $(UsrID):$(GrpID) --shm-size 16G -v $(SRC):/src/workspace -v $(CHESTX):/ChestX raflow_next bash

dbash: build_next
	$(DOCKER) run -it -d --name=$(CONTNAME) -u $(UsrID):$(GrpID) --shm-size 16G -v $(SRC):/src/workspace -v $(CHESTX):/ChestX raflow_next bash
	
prep: build_next
	$(DOCKER) run -it -d --name=$(CONTNAME) -u $(UsrID):$(GrpID) --shm-size 16G -v $(SRC):/src/workspace -v $(CHESTX):/ChestX -v $(RSNAP):/RSNAP -v $(COVID):/COVID -v $(Phase2):/Phase2 raflow_next bash

qual: build_next
	$(DOCKER) run -it -d --name=$(CONTNAME) -u $(UsrID):$(GrpID) --shm-size 16G -v $(qualt):/src/workspace raflow_next bash
