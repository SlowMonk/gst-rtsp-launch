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
RUN chown myuser:mygroup -R /dev
USER myuser

EXPOSE 8554

ENTRYPOINT ["/usr/bin/gst-rtsp-launch"]
CMD ["v4l2src device=/dev/video0 ! videoconvert ! queue ! x264enc ! video/x-h264, alignment=au, stream-format=byte-stream, profile=main ! h264parse ! rtph264pay name=pay0 pt=96"]
#CMD ["videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96"]
#CMD ["v4l2src device=/dev/video0 ! videoconvert ! queue ! x264enc ! video/x-h264, alignment=au, stream-format=byte-stream, profile=main ! h264parse ! mpegtsmux name=muxer ! tsparse ! rtpmp2tpay name=pay0 pt=96"]


# FROM test_base:latest AS build
# RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
# RUN apk add --no-cache gst-rtsp-server-dev
# RUN apk add --no-cache libtool
# RUN apk add --no-cache gcc
# RUN apk add --no-cache musl-dev
# COPY src/gst-rtsp-launch.c gst-rtsp-launch.c
# RUN libtool --mode=link \
#  gcc `pkg-config --cflags --libs gstreamer-1.0` \
#  -L/usr/lib/x86_64-linux-gnu -lgstrtspserver-1.0 \
#  -o gst-rtsp-launch gst-rtsp-launch.c

# FROM test_base:latest
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
# RUN chown myuser:mygroup /dev
# USER myuser

# EXPOSE 8554

# ENTRYPOINT ["/usr/bin/gst-rtsp-launch"]
# #CMD ["videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96"]
# CMD ["v4l2src device=/dev/video0 ! videoconvert ! queue ! x264enc ! video/x-h264, alignment=au, stream-format=byte-stream, profile=main ! h264parse ! mpegtsmux name=muxer ! tsparse ! rtpmp2tpay name=pay0 pt=96"]




# FROM alpine:edge AS build
# RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
# RUN apk add --no-cache gst-rtsp-server-dev
# RUN apk add --no-cache libtool
# RUN apk add --no-cache gcc
# RUN apk add --no-cache musl-dev
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

# COPY --from=build gst-rtsp-launch /usr/bin/gst-rtsp-launch

# EXPOSE 8554

# ENTRYPOINT ["/usr/bin/gst-rtsp-launch"]
# #CMD ["videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96"]
# CMD ["v4l2src device=/dev/video0 ! videoconvert ! queue ! x264enc ! video/x-h264, alignment=au, stream-format=byte-stream, profile=main ! h264parse ! mpegtsmux name=muxer ! tsparse ! rtpmp2tpay name=pay0 pt=96"]
