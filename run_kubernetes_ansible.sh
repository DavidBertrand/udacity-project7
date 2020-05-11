#!/usr/bin/env bash


# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
# dockerpath=<>
ddockerpath="bertrand282/project7"

# Step 2
# Run the Docker Hub container with kubernetes

ansible-playbook  playbook.yml --private-key=~/ssh/udacity.pem --extra-vars "image_id=${dockerpath}" -vvv


# Step 3:
# List kubernetes pods
kubectl get pods

# Step 4:
# Forward the container port to a host
kubectl port-forward $podname 8000:80
