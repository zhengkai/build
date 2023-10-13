#!/bin/bash

NAME="gptweb"
IMAGE="chenzhaoyu94/chatgpt-web"

sudo docker pull "$IMAGE"

sudo docker stop "$NAME"
sudo docker rm "$NAME"

sudo docker run -d --name "$NAME" \
	--env "OPENAI_API_KEY=zhengkai.gptweb" \
	--env "OPENAI_API_BASE_URL=http://10.0.84.49:22035" \
	--env "OPENAI_API_MODEL=gpt-4" \
	-p 127.0.0.1:21001:3002 \
	--restart always \
	"$IMAGE"
