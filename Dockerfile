# Stage 1: Base Image with A1111 pre-installed
ARG BASE_IMAGE=ashleykza/a1111:1.10.1
FROM ${BASE_IMAGE} AS base

# Prevents prompts from packages asking for user input during installation
ENV DEBIAN_FRONTEND=noninteractive
# Prefer binary wheels over source distributions for faster pip installations
ENV PIP_PREFER_BINARY=1 
# Ensures output from python is printed immediately to the terminal without buffering
ENV PYTHONUNBUFFERED=1 
# Speed up some cmake builds
ENV CMAKE_BUILD_PARALLEL_LEVEL=8

ARG INDEX_URL

# Stage 2: Kohya_ss Installation
FROM base AS kohya-install
ARG KOHYA_VERSION
ARG KOHYA_TORCH_VERSION
ARG KOHYA_XFORMERS_VERSION
WORKDIR /
COPY kohya_ss/requirements* ./
COPY --chmod=755 build/install_kohya.sh ./
RUN /install_kohya.sh && rm /install_kohya.sh
COPY --chmod=755 kohya_ss/gui.sh ./kohya_ss/gui.sh

# Copy the accelerate configuration
COPY kohya_ss/accelerate.yaml ./

# Stage 3: ComfyUI Installation
FROM kohya-install AS comfyui-install
ARG COMFYUI_VERSION
ARG COMFYUI_TORCH_VERSION
ARG COMFYUI_XFORMERS_VERSION
WORKDIR /
# COPY --chmod=755 build/install_comfyui.sh ./
# RUN /install_comfyui.sh && rm /install_comfyui.sh


# RUN /ComfyUI/venv/bin/pip install -U comfy-cli --no-cache-dir

RUN rm -rf venv && python3 -m venv venv

RUN . venv/bin/activate && pip install --upgrade pip && which python \
 && python --version

# Install comfy-cli
RUN . /venv/bin/activate && pip install comfy-cli

# Install ComfyUI
# RUN /usr/bin/yes | comfy --workspace /comfyui install --cuda-version 12.1 --nvidia --version 0.3.4
RUN . /venv/bin/activate && /usr/bin/yes | comfy --workspace /ComfyUI install --cuda-version 12.4 --nvidia

# Disable tracking prompt and restore snapshot
COPY --chmod=755 scripts/restore_snapshot.sh /restore_snapshot.sh
COPY --chmod=755 scripts/snapshot.json /snapshot.json
RUN . venv/bin/activate && /restore_snapshot.sh


# Copy ComfyUI Extra Model Paths
COPY comfyui/extra_model_paths.yaml /ComfyUI/

# Stage 4: Tensorboard Installation
FROM comfyui-install AS tensorboard-install
WORKDIR /
COPY --chmod=755 build/install_tensorboard.sh ./
RUN /install_tensorboard.sh && rm /install_tensorboard.sh

# Stage 5: Finalise Image
FROM tensorboard-install AS final

# Remove existing SSH host keys
RUN rm -f /etc/ssh/ssh_host_*

# NGINX Proxy config
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Application Manager config
COPY app-manager/config.json /app-manager/public/config.json

# Set template version
ARG RELEASE
ENV TEMPLATE_VERSION=${RELEASE}

# Copy the scripts
WORKDIR /
COPY --chmod=755 scripts/* ./

# Start the container
SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/start.sh" ]