# rovio_docker
ROS + Rovio + Docker + X11 + testdata demonstration

## Создать рабочую дирректорию, например rvdir
```
mkdir rvdir && cd rvdir
```
## Скачать репозиторий и тестовый набор данных
```
git clone https://github.com/katafoxi/rovio_docker.git && \
wget http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/machine_hall/MH_01_easy/MH_01_easy.bag ./rosbag_testdata && \
cd rovio_docker
```
## Выбор платформы
Например, для платформы arm64v8 в Dockerfile закоментировать одну строку, раскоментировать другую.
```
#FROM ros:noetic-ros-base
FROM arm64v8/ros:noetic-ros-base
```
## ROVIO + X11
Для корректного запуска ROVIO в контейнер с инфраструктурой ROS + ROVIO необходимо прикрутить возможность общаться с X11-сервером операционной системы.
Для этого используется решение из этих источников [source 1](https://dzone.com/articles/docker-x11-client-via-ssh) и [stackoverflow](https://stackoverflow.com/questions/71245228/running-x-server-using-docker)
В частности необходимо сгенерировать и передать в контейнер файл $HOME/.Xauthority (docker-compose.yaml)  и переменную $DISPLAY (Dockerfile).
Для этого команда (исправить)
```
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -
```
## Запуск
Если тестовый набор данных скачан и в находится в нужной папке, тогда собираем и запускаем контейнер ROS+ROVIO из папки rovio_docker
```
docker compose build && docker compose up
```
![image](https://github.com/katafoxi/rovio_docker/assets/83884504/794bf74d-2dce-4675-a599-e7535484e533)

Enjoy!
