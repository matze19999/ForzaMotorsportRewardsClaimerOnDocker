# Python2 Alpine

# Geschrieben von
# Matthias Pröll <proell.matthias@gmail.com>
# Staudigl-Druck GmbH & Co. KG
# Letzte Anpassung: 2019/10/04

FROM alpine:latest

# Labels
LABEL vendor="Staudigl-Druck GmbH & Co. KG"
LABEL maintainer="Matthias Pröll (proell.matthias@gmail.com)"
LABEL release-date="2019-10-04"

RUN apk add docker python python-dev build-base py-pip bash nano && \
    rm -rf /var/cache/apk/*

RUN pip requests

RUN '#!/usr/bin/env python\n\
import re\n\
import time\n\
import json\n\
import random\n\
import os\n\
import urllib2\n\
import argparse\n\
import urlparse\n\
import traceback\n\
\n\
\n\
URL = "https://rewards.forzamotorsport.net/en-us/redeem"\n\
MSG = {\n\
    "text": "",\n\
    "username": "ForzaBot",\n\
    "icon_emoji": ":red_car:"\n\
}\n\
\n\
\n\
class ForzaBot(object):\n\
    def __init__(self, token, webhook=None, interval=43200):\n\
        os.environ['token'] = token\n\
        self.webhook = webhook\n\
        self.interval = interval\n\
\n\
        self.cookies = 'xlaWebAuth_1={}'.format(self.token)\n\
\n\
    def check(self):\n\
        f = req(URL, cookies=self.cookies)\n\
\n\
        if f.url != URL:\n\
            if 'auth' in f.url:\n\
                self.notify("Token expired")\n\
            else:\n\
                self.notify("Failed to check Rewards - {:d}: {}".format(f.code, f.msg))\n\
            return\n\
\n\
        content = f.read()\n\
        try:\n\
            if 'rewards-btn' in content:\n\
                redeemurl = urlparse.urljoin(URL, re.search("data-redeemurl=\"(.+)\"", content).group(1))\n\
                antiforgerytoken = re.search("__RequestVerificationToken.+?value=\"(.+)?\"", content).group(1)\n\
\n\
                f = req(redeemurl, "__RequestVerificationToken={}".format(antiforgerytoken), cookies=self.cookies)\n\
                if f.code == 200:\n\
                    self.notify("Successfully claimed rewards!")\n\
                else:\n\
                    self.notify("Failed to claim rewards - {:d}: {} ({})".format(f.code, f.msg, f.read()))\n\
            else:\n\
                match = re.search("data-previous='\d+' data-current='(\d)+'", content)\n\
                self.notify("{} days left until rewards".format(int(match.group(1))))\n\
        except Exception:\n\
            self.notify("Failed to parse response: \n```python\n{}\n```".format(traceback.format_exc()))\n\
\n\
    def notify(self, text):\n\
        print(text)\n\
\n\
        if self.webhook:\n\
            msg = dict(MSG)\n\
            msg['text'] = text\n\
            req(self.webhook, "payload={}".format(json.dumps(msg)))\n\
\n\
    def run(self, daemon=False):\n\
        drift = 0\n\
        while True:\n\
            self.check()\n\
\n\
            if not daemon:\n\
                break\n\
\n\
            timeout = self.interval - drift\n\
            drift = random.randint(7200, 14400)\n\
\n\
            time.sleep(timeout + drift)\n\
\n\
\n\
def req(url, data=None, cookies=None):\n\
    o = urllib2.build_opener()\n\
    o.addheaders = [('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0')]\n\
\n\
    if cookies:\n\
        o.addheaders.append(('Cookie', cookies))\n\
\n\
    return o.open(url, data)\n\
\n\
\n\
if __name__ == '__main__':\n\
    parser = argparse.ArgumentParser(description="Forza Reward Bot")\n\
    parser.add_argument('token', help="Authentication token")\n\
    parser.add_argument('--webhook', type=str, help="Webhook to send notifications to")\n\
    parser.add_argument('--daemon', '-d', action='store_true', default=False, help="Run as daemon")\n\
    parser.add_argument('--interval', '-i', type=int, default=43200, help="Interval for checks when running in daemon mode. A random amount of between 2 and 4 hours is added on top")\n\
    args = parser.parse_args()\n\
\n\
    bot = ForzaBot(args.token, args.webhook, args.interval)\n\
    bot.run(args.daemon)\n\
' > /bot.py

RUN cd /

CMD ["python", "bot.py"]
