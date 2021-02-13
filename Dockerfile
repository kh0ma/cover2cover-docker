FROM python:alpine

LABEL maintainer="marcello.desales@gmail.com"
LABEL origin="https://github.com/marcellodesales/cover2cover"

COPY cover2cover.py /tool/cover2cover.py
COPY entrypoint.sh /entrypoint.sh

VOLUME /app

ENTRYPOINT ["/entrypoint.sh"]
