ARG ROSDISTRO=foxy

FROM ros:$ROSDISTRO

ARG ROSDISTRO

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive


# Install any needed packages then clean up apt cache
# Build tools and general ROS tools
RUN apt-get update && apt-get install -y \
    software-properties-common \
    ssh \
    git \
    python3-pip \
    python3-vcstool \
    build-essential \
    cmake \
    python3-colcon-common-extensions \
    python3-flake8 \
    python3-pytest-cov \
    python3-rosdep \
    python3-setuptools \
    python3-vcstool \
    wget \
    ros-$ROSDISTRO-rqt \
    ros-$ROSDISTRO-rqt-topic \
    ros-$ROSDISTRO-rqt-top \
    ros-$ROSDISTRO-rqt-srv \
    ros-$ROSDISTRO-rqt-shell \
    ros-$ROSDISTRO-rqt-service-caller \
    ros-$ROSDISTRO-rqt-publisher \
    ros-$ROSDISTRO-rqt-reconfigure \
    ros-$ROSDISTRO-rqt-plot \
    ros-$ROSDISTRO-rqt-msg \
    ros-$ROSDISTRO-rqt-graph \
    ros-$ROSDISTRO-rqt-console \
    ros-$ROSDISTRO-rqt-common-plugins \
    ros-$ROSDISTRO-rqt-action \
    ros-$ROSDISTRO-rviz2 \
    ros-$ROSDISTRO-ros2-control \
    ros-$ROSDISTRO-ros2-controllers \
    python3-pykdl

RUN apt-get update && apt-get install -y \
    libbullet-dev \
    libasio-dev \
    libtinyxml2-dev \
    libcunit1-dev

RUN pip3 install -U \
    argcomplete \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures \
    pytest \
    pyassimp==4.1.3 

# Moveit 2 build process
RUN mkdir -p /moveit_ws/src
WORKDIR /moveit_ws/src
RUN ["/bin/bash", "-c", "source /opt/ros/foxy/setup.bash &&\
    git clone https://github.com/ros-planning/moveit2.git -b foxy &&\
    vcs-import < moveit2/moveit2.repos || true && \
    apt update && \
    rosdep install -r --from-paths . --ignore-src --rosdistro foxy -y"]

# reduce size by removing apt cache
RUN ["/bin/bash", "-c", "rm -rf /var/lib/apt/lists/*"]

WORKDIR /moveit_ws
RUN ["/bin/bash", "-c", "source /opt/ros/foxy/setup.bash &&\
    colcon build --executor sequential --cmake-args -DCMAKE_BUILD_TYPE=Release"]


COPY ./entrypoint.sh /entrypoint.sh
RUN ["/bin/bash", "-c", " chmod 777 /entrypoint.sh"]
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["bash"]


