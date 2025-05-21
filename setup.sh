git clone https://github.com/ai-dynamo/dynamo.git
cd dynamo
git checkout nnshah1/0.2.0-msbuild # special branch for the workshop

apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq libffi-dev python3-dev python3-pip python3-venv git

curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

# Create and activate virtual environment
rm -rf /opt/dynamo/venv
uv venv /opt/dynamo/venv --python 3.12
source /opt/dynamo/venv/bin/activate

# Install NIXL
rm -rf /opt/nixl
GIT_TERMINAL_PROMPT=0 git clone https://github.com/ai-dynamo/nixl.git /opt/nixl && cd /opt/nixl && git checkout $NIXL_COMMIT
if [ "$ARCH" = "arm64" ]; then \
    cd /opt/nixl && uv pip install . --config-settings=setup-args="-Dgds_path=/usr/local/cuda/targets/sbsa-linux/"; \
else \
    cd /opt/nixl && uv pip install . ; \
fi

# Install required packages
uv pip install ai-dynamo[vllm]==0.2.0 genai-perf jupyterlab huggingface-hub[cli]

# Function to retry commands with exponential backoff
retry_with_backoff() {
    local max_attempts=5
    local timeout=1
    local attempt=1
    local exitcode=0

    while (( attempt <= max_attempts ))
    do
        "$@"
        exitcode=$?

        if [[ $exitcode == 0 ]]
        then
            break
        fi

        echo "Command failed (attempt $attempt/$max_attempts). Retrying in $timeout seconds..."
        sleep $timeout
        attempt=$(( attempt + 1 ))
        timeout=$(( timeout * 2 ))
    done

    if [[ $exitcode != 0 ]]
    then
        echo "Command failed after $max_attempts attempts"
    fi

    return $exitcode
}

# Download model with retry logic
retry_with_backoff huggingface-cli download deepseek-ai/DeepSeek-R1-Distill-Llama-8B

jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --ServerApp.root_dir=/workspace/dynamo-build-workshop




