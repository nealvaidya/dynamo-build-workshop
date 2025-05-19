First, make sure you've executed the `setup.sh` script.
Among other things, this script will clone the `dynamo` repo and build the `dynamo:dev` container.

The first step in deployment is to launch the runtime dependencies of dynamo, `etcd` and `nats.io`. You can do that with the docker compose file:

```
cd dynamo
docker compose -f deploy/docker-compose.yml up --detach
```

Next, launch the dynamo dev container with the following command. Make sure to include the HF_CACHE argument.

```
./container/run.sh --mount-workspace -it --image dynamo:dev --name dynamo-dev --hf-cache $HOME/.cache/huggingface
```