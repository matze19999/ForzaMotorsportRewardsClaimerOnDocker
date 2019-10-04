#!/bin/bash

if [[ -n $webhook  &&  -n $interval ]]; then
    python /bot.py $token --daemon --interval $interval --webhook $webhook
elif [[ -z $webhook  &&  -n $interval ]]; then
    python /bot.py $token --daemon --interval $interval
elif [[ -n $webhook  &&  -z $interval ]]; then
    python /bot.py $token --daemon --webhook $webhook
elif [[ -z $webhook  &&  -z $interval ]]; then
    python /bot.py $token --daemon
fi

while sleep $interval; do
    pgrep bot.py
    if [ $? == 1 ]; then
        if [[ -n $webhook  &&  -n $interval ]]; then
            python /bot.py $token --daemon --interval $interval --webhook $webhook
        elif [[ -z $webhook  &&  -n $interval ]]; then
            python /bot.py $token --daemon --interval $interval
        elif [[ -n $webhook  &&  -z $interval ]]; then
            python /bot.py $token --daemon --webhook $webhook
        elif [[ -z $webhook  &&  -z $interval ]]; then
            python /bot.py $token --daemon
        fi
    fi
done
exit 1;