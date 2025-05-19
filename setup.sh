echo "Please enter your Hugging Face token."
echo "You can get a token from https://huggingface.co/settings/tokens"
echo "If you don't have a token, please reach out to a workshop instructor."
read -p "HF_TOKEN: " HF_TOKEN

git clone https://github.com/ai-dynamo/dynamo.git
cd dynamo
git checkout nnshah1/0.2.0-msbuild # special branch for the workshop

docker compose -f deploy/docker-compose.yml pull
docker build -f tutorials/Dockerfile . -t dynamo:dev

pip install -U "huggingface_hub[cli]"
huggingface-cli download deepseek-ai/DeepSeek-R1-Distill-Llama-8B

# ./dynamo/container/run.sh -it -v "${PWD}/dynamo-build-workshop:/workspace" --image dynamo:dev --name dynamo-dev