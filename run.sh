#!/bin/bash

if [[ -n $webhook  &&  -n $interval ]]; then
    python /bot.py $token -interval $interval --webhook $webhook
elif [[ -z $webhook  &&  -n $interval ]]; then
    python /bot.py $token --interval $interval
elif [[ -n $webhook  &&  -z $interval ]]; then
    python /bot.py $token --webhook $webhook
elif [[ -z $webhook  &&  -z $interval ]]; then
    python /bot.py $token
fi

while sleep $interval; do
    pgrep "bot.py" && pgrep "python"
    if [ $? == 1 ]; then
        if [[ -n $webhook  &&  -n $interval ]]; then
            python /bot.py $token --interval $interval --webhook $webhook
        elif [[ -z $webhook  &&  -n $interval ]]; then
            python /bot.py $token --interval $interval
        elif [[ -n $webhook  &&  -z $interval ]]; then
            python /bot.py $token --webhook $webhook
        elif [[ -z $webhook  &&  -z $interval ]]; then
            python /bot.py $token
        fi
    fi
done
exit 1;
