USERNAME=gramaziokohler
VERSION=$(shell cat VERSION)

# We need to check if we're running inside WSL (Bash on Windows) or real bash
DOCKER=docker
PROCESS_VERSION=$(grep -o Microsoft /proc/version | head -n 1)
ifeq ($(words PROCESS_VERSION), 1)
	DOCKER='docker.exe'
endif

.PHONY: all build

all: build

build: build-ros-base build-ros-ur-planner

build-ros-base:
	$(eval IMAGE:=ros-base)
	@echo 'Building $(IMAGE) image, version $(VERSION)'
	@cd $(IMAGE);$(DOCKER) build --rm -t $(USERNAME)/$(IMAGE):$(VERSION) -t $(USERNAME)/$(IMAGE):latest .
	@echo \\n****************************************************************\\n

build-ros-ur-planner:
	$(eval IMAGE:=ros-ur-planner)
	@echo 'Building $(IMAGE) image, version $(VERSION)'
	@cd $(IMAGE);$(DOCKER) build --rm -t $(USERNAME)/$(IMAGE):$(VERSION) -t $(USERNAME)/$(IMAGE):latest .
	@echo \\n****************************************************************\\n

release: release-ros-base release-ros-ur-planner

release-ros-base:
	$(eval IMAGE:=ros-base)
	@echo 'Publishing $(IMAGE) image to dockerhub'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)

release-ros-ur-planner:
	$(eval IMAGE:=ros-ur-planner)
	@echo 'Publishing $(IMAGE) image to dockerhub'
	@$(DOCKER) push $(USERNAME)/$(IMAGE)
