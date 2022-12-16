FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN rm /etc/apt/sources.list.d/cuda.list
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub

#get deps
RUN apt-get -y update 
RUN apt-get -y install \
        git g++ wget make libprotobuf-dev protobuf-compiler curl gnupg2 lsb-release

# setup python
RUN apt-get -y install \
        python3-dev python3-pip python3-setuptools python-openssl 

# setup lib
RUN apt-get -y install \
        libopencv-dev libgoogle-glog-dev libboost-all-dev libhdf5-dev libatlas-base-dev libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev

# install ROS2 Foxy
 RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' && \
    apt update && apt install -y ros-foxy-desktop && \ 
    pip3 install --upgrade pip && pip3 install -U argcomplete

# install ROS2 plugin
RUN apt install -y ros-foxy-cv-bridge

#for python api
RUN pip3 install -U pip && \
    pip3 install numpy opencv-python cython && \
    pip3 install pycocotools empy lark_parser colcon-common-extensions

# install powerline-shell
RUN apt-get -y update && \
    apt-get -y install vim
RUN pip3 install powerline-shell
RUN mkdir -p /root/Programs/Settings && \
    touch /root/Programs/Settings/powerlineSetup_CRLF.txt && \
    touch /root/Programs/Settings/powerlineSetup.txt 
COPY settings/powerline/powerlineSetup.txt /root/Programs/Settings/powerlineSetup_CRLF.txt
RUN sed "s/\r//g" /root/Programs/Settings/powerlineSetup_CRLF.txt > /root/Programs/Settings/powerlineSetup.txt && \
    cat /root/Programs/Settings/powerlineSetup.txt >> /root/.bashrc
RUN mkdir -p /root/.config/powerline-shell 
COPY settings/powerline/config.json /root/.config/powerline-shell/config.json

#replace cmake as old version has CUDA variable bugs
RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-Linux-x86_64.tar.gz && \
tar xzf cmake-3.23.1-Linux-x86_64.tar.gz -C /opt && \
rm cmake-3.23.1-Linux-x86_64.tar.gz
ENV PATH="/opt/cmake-3.23.1-Linux-x86_64/bin:${PATH}"

#get openpose
WORKDIR /openpose
RUN git clone -b feature/shigure_openpose https://github.com/Rits-Interaction-Laboratory/openpose.git .

#build it
WORKDIR /openpose/build
RUN cmake -DBUILD_PYTHON=ON .. && make -j `nproc`
WORKDIR /openpose

RUN cd /openpose/build/python/openpose && \
	make install

RUN cd /openpose/build/python/openpose && \
    cp ./pyopenpose.cpython-38-x86_64-linux-gnu.so /usr/local/lib/python3.8/dist-packages && \
	cd /usr/local/lib/python3.8/dist-packages && \
	ln -s pyopenpose.cpython-38-x86_64-linux-gnu.so pyopenpose 

ENV LD_LIBRARY_PATH=/openpose/build/python/openpose

# setup openpose_ros2
RUN mkdir -p /ros2_ws/src
COPY openpose_ros2/ /ros2_ws/src/openpose_ros2
COPY settings/shigure/params.yml /params.yml
COPY settings/shigure/run.bash /run.bash
COPY settings/shigure/launch.bash /launch.bash

RUN  . /opt/ros/foxy/setup.sh && cd /ros2_ws  && /bin/bash -c "python3 -m colcon build --base-paths src/openpose_ros2" && \
    echo "# ROS2 Settings" >> ~/.bashrc && \
    . install/setup.sh && echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc && \
    echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

# setup shigure_tool
COPY settings/shigure/shigure_tool_setup.txt /root/Programs/Settings/shigure_tool_setup.txt
RUN cd / && \
    git clone https://github.com/Rits-Interaction-Laboratory/shigure_tools.git
RUN cat /root/Programs/Settings/shigure_tool_setup.txt >> /root/.bashrc

CMD ["/bin/bash"]
