FROM amd64/debian:unstable-slim as qemu

ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
  && apt-get update -qq \
  && apt-get install -qq -y qemu-user-static

FROM python:3.7-alpine

COPY --from=qemu /usr/bin/qemu-arm-static /usr/bin

# install
RUN mkdir /opt/mqtt-exporter/
COPY exporter.py /opt/mqtt-exporter/
COPY requirements.txt ./
RUN pip install -r requirements.txt

# clean
RUN rm requirements.txt

CMD [ "python", "/opt/mqtt-exporter/exporter.py" ]
