sudo gst-launch-1.0 -vvv -m rtspsrc location=rtsp://0.0.0.0:8554/test ! rtph264depay ! h264parse ! decodebin ! videoconvert ! autovideosink sync=false


#sudo gst-launch-1.0 -vvv rtspsrc location=rtsp://0.0.0.0:8554/test ! rtph264depay ! h264parse ! decodebin ! videoconvert ! xvimagesink sync=false
