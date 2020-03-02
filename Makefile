help:
	@cat Makefile

CONTNAME?="rbf9_memTest"
GPU?=0

DATA?="/data/usr/rbf9/AERTS"
SRC?="${HOME}/memTest"

TF2_FILE= ${HOME}/DockerDepot/TF2_Dockerfile
DOCKER2=NV_GPU=$(GPU) nvidia-docker
PYTHON_VERSION2?=3.7
CUDA_VERSION2?=10.0
CUDNN_VERSION2?=7
USERID?=$(id -u)
USEG?=$(id -g)

rfn_FILE= ${HOME}/DockerDepot/rfNext_Dockerfile


build:
	docker build -t raflow --build-arg python_version=$(PYTHON_VERSION2) --build-arg cuda_version=$(CUDA_VERSION2) --build-arg cudnn_version=$(CUDNN_VERSION2) -f $(TF2_FILE) .

bash: build
	$(DOCKER2) run -it --rm --name=$(CONTNAME) -v $(SRC):/src/workspace -v $(DATA):/data raflow bash

dbash: build
	$(DOCKER2) run -it -d --name=$(CONTNAME) -v $(SRC):/src/workspace -v $(DATA):/data raflow bash

build_next:
	$(DOCKER2) build -t rtf_next --build-arg USRID=$(USER) --build-arg python_version=$(PYTHON_VERSION2) --build-arg cuda_version=$(CUDA_VERSION2) --build-arg cudnn_version=$(CUDNN_VERSION2) -f $(rfn_FILE) .

nexttf: build_next
	$(DOCKER2) run -it -d --name=$(CONTNAME) -u $(USERID):$(USEG) -v $(SRC):/src/workspace -v $(DATA):/data rtf_next bash