#!/bin/bash
apt -y update
apt -y install build-essential
yum -y groupinstall "Development Tools"
apt -y install python3-dev

#apt install -y python3.12

#update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

#update-alternatives --install /usr/bin/python python /usr/bin/python3.12 2

#echo "2" | update-alternatives --config python

#apt install -y python-pip 
#python /workspace/ComfyUI/get-pip.py

#pip install --upgrade pip
#pip install setuptools

#pip install -r /workspace/ComfyUI/initial-requirements.txt

# Install additional requirements
pip uninstall -y torchvision torch torchsde torchaudio xformers transformers
pip install torchvision torch==2.5.1 torchsde torchaudio transformers==4.45.2
pip install -r /workspace/ComfyUI/requirements.txt

#pip install -r /workspace/ComfyUI/mixlab_requirements.txt



#cd /workspace/ComfyUI/custom_nodes/comfyui-mixlab-nodes/

#pip install -r /workspace/ComfyUI/custom_nodes/comfyui-mixlab-nodes/requirements.txt



