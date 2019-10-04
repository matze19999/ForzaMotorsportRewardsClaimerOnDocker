# Python2 Alpine

# Geschrieben von
# Matthias Pröll <proell.matthias@gmail.com>
# Letzte Anpassung: 2019/10/04

FROM alpine:latest

# Labels
LABEL maintainer="Matthias Pröll (proell.matthias@gmail.com)"
LABEL release-date="2019-10-04"

RUN apk add python bash nano vim && \
    rm -rf /var/cache/apk/*

ADD /bot.py /

ADD /run.sh /

RUN chmod +x /run.sh /bot.py

RUN cd /

CMD ["/bin/bash", "run.sh"]
