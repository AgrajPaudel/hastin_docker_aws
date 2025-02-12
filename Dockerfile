# Import necessary base images
FROM nvidia/cuda:11.8.0-base-ubuntu22.04 as runtime

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set environment variables
ENV SHELL=/bin/bash
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /

# Set up system dependencies
RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends \
        build-essential git wget curl bash \
        libgl1 software-properties-common \
        openssh-server nginx rsync python3-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# Set up Python and pip
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py

RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Upgrade pip & install necessary Python packages
RUN pip install --upgrade --no-cache-dir pip setuptools wheel

# Clone `hastin_docker_aws` to get `requirements.txt`, `mixlab_requirements.txt`, and scripts
RUN git clone https://github.com/agrajpaudel/hastin_docker_aws.git /workspace/hastin_docker

# Install PyTorch & dependencies
RUN pip uninstall -y torchvision torch torchsde torchaudio xformers transformers && \
    pip install torchvision torch==2.5.1 torchsde torchaudio transformers==4.45.2

# Install dependencies from the GitHub repo
RUN pip install -r /workspace/hastin_docker/requirements.txt 

# NGINX Proxy Setup
COPY --from=proxy nginx.conf /etc/nginx/nginx.conf
COPY --from=proxy readme.html /usr/share/nginx/html/readme.html
COPY README.md /usr/share/nginx/html/README.md

# Copy `start.sh` and `pre_start.sh` from cloned repo
COPY /workspace/hastin_docker/pre_start.sh /pre_start.sh
COPY /workspace/hastin_docker/start.sh /start.sh
RUN chmod +x /start.sh /pre_start.sh

# Start container
CMD [ "/start.sh" ]
