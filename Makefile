# Go parameters
GOCMD=GO111MODULE=on CGO_ENABLED=0 go
GOBUILD=$(GOCMD) build
GOTEST=$(GOCMD) test

all: test build
build:
	rm -rf dist/
	mkdir -p dist/conf
	cp cmd/discovery/discovery-example.toml dist/conf/discovery.toml
	$(GOBUILD) -o dist/bin/discovery cmd/discovery/main.go

test:
	$(GOTEST) -v ./...

clean:
	rm -rf dist/

run:
	nohup dist/bin/discovery -conf dist/conf -confkey discovery.toml -log.dir dist/log & > dist/nohup.out

stop:
	pkill -f dist/bin/discovery

# 定义一个制作镜像的函数
define docker_build_image
	@# 第一个参数是程序名称
	@# 第二个参数是镜像的tag
	@# 第三个参数Dockerfile文件路径
	@# 第四个参数Docker制作镜像的路径
	docker build ${BUILD_ARGS} -t clouderwork/${1}:${2} -f ${3} ${4}
endef

# 编译可执行程序 打包基础镜像
.PHONY: build-base-images

build-base-images:
	$(call docker_build_image,discovery,latest,./Dockerfile,.)

