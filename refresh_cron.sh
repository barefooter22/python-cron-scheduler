#!/bin/bash
echo "refreshing cron changes..."
crontab /etc/cron.d/python-scheduler
service cron reload