echo "########### Building test_base ###############"
sudo docker build -t test_base .
echo "############### Run server ###################"
sudo docker run -it --rm \
	--privileged \
	--device /dev/video0 \
	-v /dev/video0:/dev/video0 \
	-p 8554:8554 \
       	test_base:latest

#docker run --rm -it \
#  --privileged \
#  --volume=/dev:/dev \
#  -p 8554:8554 \
#  test_base:latest


#docker run --rm -it \
#  --privileged \
#  --device=/dev/video0 \
#  -p 8554:8554 \
#  test_base:latest
#sudo docker run --rm -p 8554:8554 test_base:latest
