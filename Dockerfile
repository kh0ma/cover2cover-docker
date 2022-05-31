FROM python:alpine

LABEL maintainer="kh0maneko.dp@gmail.com"
LABEL origin="https://github.com/kh0ma/cover2cover-docker"

COPY cover2cover.py /tool/cover2cover.py
COPY entrypoint.sh /entrypoint.sh

VOLUME /app

ENTRYPOINT ["/entrypoint.sh"]
