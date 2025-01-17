#############################################################################################################################
# FROM ubuntu:latest AS build
# RUN apt-get update && apt-get install -y \
#     libgstrtspserver-1.0-dev \
#     libgstreamer1.0-dev \
#     libgstreamer-plugins-base1.0-dev \
#     libtool \
#     gcc \
#     pkg-config \
#     libgstreamer1.0-0 \
#     gstreamer1.0-tools \
#     gstreamer1.0-plugins-good \
#     gstreamer1.0-plugins-bad \
#     gstreamer1.0-plugins-ugly \
#     gstreamer1.0-libav \
#     libgstreamer-plugins-base1.0-dev \
#     libgstrtspserver-1.0-0 \
#     libjansson4 \
#     libyaml-cpp-dev \
#     libjsoncpp-dev \
#     protobuf-compiler \
#     gcc \
#     make \
#     git \
#     python3

# COPY src/gst-rtsp-launch.c gst-rtsp-launch.c
# RUN gcc -g -Wall `pkg-config --cflags --libs gstreamer-1.0` \
#     -lgstrtspserver-1.0 \
#     -o gst-rtsp-launch gst-rtsp-launch.c

# FROM ubuntu:latest
# RUN apt-get update && apt-get install -y \
#     apt-utils \
#     gstreamer1.0-plugins-* \
#     gstreamer1.0-* \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     software-properties-common \
#     v4l-utils \
#     net-tools \
#     iputils-ping \
#     nano

# COPY --from=build gst-rtsp-launch /usr/bin/gst-rtsp-launch

# # Grant necessary privileges to access /dev/video0
# RUN groupadd -r mygroup && useradd -r -g mygroup myuser
# RUN chown myuser:mygroup -R /dev
# USER myuser

# EXPOSE 8554

# ENTRYPOINT ["/usr/bin/gst-rtsp-launch"]
# CMD ["videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96"]
# #CMD ["v4l2src device=/dev/video0 ! videoconvert ! queue ! x264enc ! video/x-h264, alignment=au, stream-format=byte-stream, profile=main ! h264parse ! rtph264pay name=pay0 pt=96"]



#############################################################################################################################
# FROM alpine:edge AS build
# RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
# RUN apk add --no-cache gst-rtsp-server-dev
# RUN apk add --no-cache libtool
# RUN apk add --no-cache gcc
# RUN apk add --no-cache musl-dev
# RUN apk add --no-cache pkgconf 
# COPY src/gst-rtsp-launch.c gst-rtsp-launch.c
# RUN libtool --mode=link \
#  gcc `pkg-config --cflags --libs gstreamer-1.0` \
#  -L/usr/lib/x86_64-linux-gnu -lgstrtspserver-1.0 \
#  -o gst-rtsp-launch gst-rtsp-launch.c

# FROM alpine:edge
# RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
# RUN apk add --no-cache gst-rtsp-server
# RUN apk add --no-cache gst-plugins-base
# RUN apk add --no-cache gst-plugins-ugly
# RUN apk add --no-cache gst-plugins-good
# RUN apk add --no-cache gst-plugins-bad
# RUN apk add --no-cache gst-libav
# RUN apk add --no-cache v4l-utils

# COPY --from=build gst-rtsp-launch /usr/bin/gst-rtsp-launch

# # Grant necessary privileges to access /dev/video0
# RUN addgroup -S mygroup && adduser -S myuser -G mygroup
# RUN apk add --no-cache shadow
# RUN usermod -a -G root myuser
# RUN chown myuser:mygroup -R /dev
# RUN chmod -R 777 /dev
# RUN mkdir TEST 
# USER myuser
# #RUN chmod a+rw /dev/video0


# EXPOSE 8554

# ENTRYPOINT ["/usr/bin/gst-rtsp-launch"]
# CMD ["v4l2src device=/dev/video0 ! videoconvert ! queue ! x264enc ! video/x-h264, alignment=au, stream-format=byte-stream, profile=main ! h264parse ! rtph264pay name=pay0 pt=96"]
# #CMD ["videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96"]
# #CMD ["v4l2src device=/dev/video0 ! videoconvert ! queue ! x264enc ! video/x-h264, alignment=au, stream-format=byte-stream, profile=main ! h264parse ! mpegtsmux name=muxer ! tsparse ! rtpmp2tpay name=pay0 pt=96"]
# #CMD ["udpsrc port=8554 ! application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264 ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! rtph264pay pt=96 name=pay0"]


FROM alpine:edge AS build
RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk add --no-cache gst-rtsp-server-dev
RUN apk add --no-cache libtool
RUN apk add --no-cache gcc
RUN apk add --no-cache musl-dev
RUN apk add --no-cache pkgconf 
COPY src/gst-rtsp-launch.c gst-rtsp-launch.c
RUN libtool --mode=link \
 gcc `pkg-config --cflags --libs gstreamer-1.0` \
 -L/usr/lib/x86_64-linux-gnu -lgstrtspserver-1.0 \
 -o gst-rtsp-launch gst-rtsp-launch.c

FROM alpine:edge
RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk add --no-cache gst-rtsp-server
RUN apk add --no-cache gst-plugins-base
RUN apk add --no-cache gst-plugins-ugly
RUN apk add --no-cache gst-plugins-good
RUN apk add --no-cache gst-plugins-bad
RUN apk add --no-cache gst-libav
RUN apk add --no-cache v4l-utils

COPY --from=build gst-rtsp-launch /usr/bin/gst-rtsp-launch

# Grant necessary privileges to access /dev/video0
RUN addgroup -S mygroup && adduser -S myuser -G mygroup
RUN apk add --no-cache shadow
#RUN chown myuser:mygroup -R /dev
#RUN chmod -R a+rwX /dev
RUN usermod -a -G root myuser

#USER myuser
EXPOSE 8554

ENTRYPOINT ["/usr/bin/gst-rtsp-launch"]
CMD ["v4l2src device=/dev/video0 ! videoconvert ! queue ! x264enc ! video/x-h264, alignment=au, stream-format=byte-stream, profile=main ! h264parse ! rtph264pay name=pay0 pt=96"]