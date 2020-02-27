help:
	@cat Makefile

CONTNAME?="rbf9_memTest"
GPU?=0

DATA?="/data/usr/rbf9/AERTS"
SRC?="${HOME}/memTest"

KERAS_FILE= ${HOME}/DockerDepot/Keras_Dockerfile
DOCKER=NV_GPU=$(GPU) nvidia-docker
BACKEND=tensorflow
PYTHON_VERSION?=3.6
CUDA_VERSION?=10.0
CUDNN_VERSION?=7

TF2_FILE= ${HOME}/DockerDepot/TF2_Dockerfile
DOCKER2=NV_GPU=$(GPU) nvidia-docker
PYTHON_VERSION2?=3.8
CUDA_VERSION2?=10.2
CUDNN_VERSION2?=7


build:
	docker build -t keras --build-arg python_version=$(PYTHON_VERSION) --build-arg cuda_version=$(CUDA_VERSION) --build-arg cudnn_version=$(CUDNN_VERSION) -f $(KERAS_FILE) .

bash: build
	$(DOCKER) run -it --rm --name=$(CONTNAME) -v $(SRC):/src/workspace -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras bash

dbash: build
	$(DOCKER) run -it -d --name=$(CONTNAME) -v $(SRC):/src/workspace -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras bash


build2:
	docker build -t raflow2 --build-arg python_version=$(PYTHON_VERSION2) --build-arg cuda_version=$(CUDA_VERSION2) --build-arg cudnn_version=$(CUDNN_VERSION2) -f $(TF2_FILE) .

bash2: build2
	$(DOCKER2) run -it --rm --name=$(CONTNAME) -v $(SRC):/src/workspace -v $(DATA):/data raflow2 bash

dbash2: build2
	$(DOCKER2) run -it -d --name=$(CONTNAME) -v $(SRC):/src/workspace -v $(DATA):/data raflow2 bash

