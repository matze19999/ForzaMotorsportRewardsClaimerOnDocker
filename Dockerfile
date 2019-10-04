# Python2 Alpine

# Geschrieben von
# Matthias Pröll <proell.matthias@gmail.com>
# Letzte Anpassung: 2019/10/04

FROM alpine:latest

# Labels
LABEL maintainer="Matthias Pröll (proell.matthias@gmail.com)"
LABEL release-date="2019-10-04"

RUN apk add python python-dev build-base py-pip bash nano vim && \
    rm -rf /var/cache/apk/*

RUN pip install requests

ADD /bot.py /

ADD /run.sh /

RUN cd /

CMD ["/bin/bash", "run.sh"]
