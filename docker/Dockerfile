ARG BASE_IMAGE=ctumrs/mrs_uav_system:latest
ARG PPA_VARIANT=unstable

FROM ${BASE_IMAGE}

ARG PPA_VARIANT

RUN apt-get -y update

# workaround interractive prompts during apt installations
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install keyboard-configuration

# INSTALL the MRS UAV System

RUN apt-get -y install software-properties-common curl bash

RUN curl https://ctu-mrs.github.io/ppa2-${PPA_VARIANT}/add_ppa.sh | bash

RUN apt-get -y install ros-jazzy-mrs-uav-core

CMD ["/ros_entrypoint.sh"]
