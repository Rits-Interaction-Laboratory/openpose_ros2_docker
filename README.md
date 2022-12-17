# Openpose ROS2 Docker

![openpose_ros2_docker](https://img.shields.io/badge/openpose_ros2-docker-blue)

en / [ja](./README_ja.md)

This repository provides an environment for running openpose_ros2 in a Docker container.

The following packages this repository depends on :
- [Rits-Interaction-Laboratory/openpose](https://github.com/Rits-Interaction-Laboratory/openpose)
  - forked from [CMU-Perceptual-Computing-Lab/openpose](https://github.com/CMU-Perceptual-Computing-Lab/openpose) 
- [Rits-Interaction-Laboratory/openpose_ros2](https://github.com/Rits-Interaction-Laboratory/openpose_ros2)
- [Rits-Interaction-Laboratory/shigure_tools](https://github.com/Rits-Interaction-Laboratory/shigure_tools)

## Required

---

- Docker


## Building

---

Getting Dependent Packages :
```bash
bash startup.sh
```

Creating Docker Image :
```bash
docker build -t openpose_ros2_docker .
```

Creating Docker container :
```bash
docker run -it --name ${container name} --gpus all --net host openpose_ros2_docker:latest
```

## Run node

---

Run the following in the docker container :
```bash
bash /launch.bash
```
