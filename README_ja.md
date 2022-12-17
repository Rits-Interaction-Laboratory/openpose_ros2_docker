# Openpose ROS2 Docker

![openpose_ros2_docker](https://img.shields.io/badge/openpose_ros2-docker-blue)

[en](./README.md) / ja

これはDockerコンテナ内でopenpose_ros2を実行するための環境を提供するリポジトリです。

このリポジトリが依存するパッケージは以下の通りです :
- [Rits-Interaction-Laboratory/openpose](https://github.com/Rits-Interaction-Laboratory/openpose)
  - forked from [CMU-Perceptual-Computing-Lab/openpose](https://github.com/CMU-Perceptual-Computing-Lab/openpose) 
- [Rits-Interaction-Laboratory/openpose_ros2](https://github.com/Rits-Interaction-Laboratory/openpose_ros2)
- [Rits-Interaction-Laboratory/shigure_tools](https://github.com/Rits-Interaction-Laboratory/shigure_tools)

## 動作要件

---

- Docker


## ビルド方法

---

依存パッケージの取得 :
```bash
bash startup.sh
```

Docker Imageの作成 :
```bash
docker build -t openpose_ros2_docker .
```

コンテナの作成 :
```bash
docker run -it --name ${コンテナ名} --gpus all --net host openpose_ros2_docker:latest
```

## ノードの起動

---

dockerコンテナ内にて以下を実行 :
```bash
bash /launch.bash
```
