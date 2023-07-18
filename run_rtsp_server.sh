sudo docker build -t test_base .
docker run --rm -it \
  --privileged \
  --volume=/dev:/dev \
  -p 8554:8554 \
  test_base:latest


#docker run --rm -it \
#  --privileged \
#  --device=/dev/video0 \
#  -p 8554:8554 \
#  test_base:latest
#sudo docker run --rm -p 8554:8554 test_base:latest
