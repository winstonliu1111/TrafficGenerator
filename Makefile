DOCKER_DEVENV_IMAGE = tg-devenv
CC = gcc
CFLAGS = -c -Wall -pthread -lm -lrt
LDFLAGS = -pthread -lm -lrt
TARGETS = client incast-client simple-client server
CLIENT_OBJS = common.o cdf.o conn.o client.o
INCAST_CLIENT_OBJS = common.o cdf.o conn.o incast-client.o
SIMPLE_CLIENT_OBJS = common.o simple-client.o
SERVER_OBJS = common.o server.o
BIN_DIR = bin
RESULT_DIR = result
CLIENT_DIR = src/client
COMMON_DIR = src/common
SERVER_DIR = src/server
SCRIPT_DIR = src/script
.PHONY: $(DOCKER_DEVENV_IMAGE) dev move

all: $(TARGETS) move

move:
	mkdir -p $(RESULT_DIR)
	mkdir -p $(BIN_DIR)
	mv *.o $(TARGETS) $(BIN_DIR)
	cp $(SCRIPT_DIR)/* $(BIN_DIR)

client: $(CLIENT_OBJS)
	$(CC) $(CLIENT_OBJS) -o client $(LDFLAGS)

incast-client: $(INCAST_CLIENT_OBJS)
	$(CC) $(INCAST_CLIENT_OBJS) -o incast-client $(LDFLAGS)

simple-client: $(SIMPLE_CLIENT_OBJS)
	$(CC) $(SIMPLE_CLIENT_OBJS) -o simple-client $(LDFLAGS)

server: $(SERVER_OBJS)
	$(CC) $(SERVER_OBJS) -o server $(LDFLAGS)

%.o: $(CLIENT_DIR)/%.c
	$(CC) $(CFLAGS) $^ -o $@

%.o: $(SERVER_DIR)/%.c
	$(CC) $(CFLAGS) $^ -o $@

%.o: $(COMMON_DIR)/%.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -rf $(BIN_DIR)/*

# start a dev docker
dev:
	docker run --name=tgenv -it --rm -v $(shell pwd):/TrafficGenerator $(DOCKER_DEVENV_IMAGE) bash

# dependency images
$(DOCKER_DEVENV_IMAGE):
	docker build -t $(DOCKER_DEVENV_IMAGE) -f ./Dockerfile.build .
