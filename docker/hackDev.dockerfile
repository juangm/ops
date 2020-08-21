FROM kalilinux/kali-rolling

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Or your actual UID, GID on Linux if not the default 1000
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt update && apt upgrade -y \
    && apt -y install --no-install-recommends apt-utils dialog 2>&1 \

    # Verify git, process tools, lsb-release (common in install instructions for CLIs) installed
    && apt -y install git procps lsb-release \

    # Install python + pip
    && apt install python3 python3-pip -y \

    # Install packages for hacking
    && apt install kali-linux-core nikto nmap sslscan sslyze metasploit-framework -y \

    # Install pylint
    && pip3 --disable-pip-version-check --no-cache-dir install pylint \

    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \

    # Clean up
    && apt autoremove -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=

# Set up environment variables
RUN export LC_CTYPE=en_US.UTF-8 \
    && export LC_ALL=en_US.UTF-8 \
    && export LANGUAGE=en_US.UTF-8
