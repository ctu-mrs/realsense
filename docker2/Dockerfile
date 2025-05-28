#FROM ubuntu:24.04
FROM ctumrs/mrs_uav_system2:latest

# Information from the higher level build pipeline to the Docker build about where the package should be searched for.
ARG PKG_LOCATION=src

# Add ubuntu user with same UID and GID as your host system, if it doesn't already exist
# Since Ubuntu 24.04, a non-root user is created by default with the name vscode and UID=1000
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN if ! id -u $USER_UID >/dev/null 2>&1; then \
        groupadd --gid $USER_GID $USERNAME && \
        useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    fi
# Add sudo support for the non-root user
RUN apt-get update && \
    apt-get install -y sudo && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Switch from root to user
USER $USERNAME

# Add user to video group to allow access to webcam
RUN sudo usermod --append --groups video $USERNAME

# Update all packages
#RUN sudo apt update && sudo apt upgrade -y
RUN sudo apt update

# common utilities
RUN sudo apt install -y ros-jazzy-realsense2*

# This packages need to be installed, RealSense node will not publish topics with those types otherwise.
# Realsense node can also publish other types of image topics, if they are installed. If you do not install them,
# you effectively disable those topics.
RUN sudo apt install -y ros-jazzy-compressed-image-transport
RUN sudo apt install -y ros-jazzy-compressed-depth-image-transport

#RUN sudo apt install -y htop

# RUN mkdir librealsense2
# RUN cd librealsense2

# Define file and directory names
# ARG ZIP_FILE="librealsense2_noble_x86_debians_beta.zip"
# ARG DOWNLOAD_URL="https://github.com/IntelRealSense/librealsense/releases/download/v2.56.3/$ZIP_FILE"

# Check if the zip file exists
# RUN if [ ! -f "$ZIP_FILE" ]; then \
#         echo "$ZIP_FILE not found. Downloading..." \
#         wget "$DOWNLOAD_URL"; \
#     fi

COPY --chown=$USERNAME:$USERNAME $PKG_LOCATION /home/$USERNAME/ws/src
COPY --chown=$USERNAME:$USERNAME $PKG_LOCATION/realsense/Docker/entrypoint.sh /home/$USERNAME/ws
RUN rosdep update
RUN rosdep install -y -r --from-paths /home/$USERNAME/ws/src
RUN . /opt/ros/jazzy/setup.sh && \
    cd /home/$USERNAME/ws && \
    colcon build --symlink-install

RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/ubuntu/.bashrc
RUN echo "source /home/$USERNAME/ws/install/setup.bash" >> /home/ubuntu/.bashrc
RUN echo "export UAV_NAME=uav1" >> /home/ubuntu/.bashrc

ENTRYPOINT ["bash", "/home/ubuntu/ws/entrypoint.sh"]