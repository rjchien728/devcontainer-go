#!/bin/bash

echo "Running post-start script..."

# Start port forwarding from container to host via socat
echo "[post-start-cmd] Forwarding ports via socat ..."

# Forward MongoDB (27017 in container → 37017 on host)
nohup socat TCP-LISTEN:27017,fork,reuseaddr TCP:host.docker.internal:37017 > /tmp/socat-mongo.log 2>&1 &

# Forward Redis (6379 in container → 7379 on host)
nohup socat TCP-LISTEN:6379,fork,reuseaddr TCP:host.docker.internal:7379 > /tmp/socat-redis.log 2>&1 &

# Forward MySQL (3306 in container → 4306 on host)
nohup socat TCP-LISTEN:3306,fork,reuseaddr TCP:host.docker.internal:4306 > /tmp/socat-mysql.log 2>&1 &

echo "post-start script done."