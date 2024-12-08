FROM python:3.10-slim-bullseye

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variable to prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1

# Set environment variable to buffer stdout
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y cron

# Copy crontab file and setup permissions
COPY crontab /etc/cron.d/python-scheduler
#copy the crontab refresh script to ensure this is scheduled to refresh cron every minute
COPY refresh_cron.sh /app/refresh_cron.sh 

#set permissions of the scheduler cron and the cron refresh script
RUN chmod 0644 /etc/cron.d/python-scheduler && crontab /etc/cron.d/python-scheduler
RUN chmod 0755 /app/refresh_cron.sh 

# Ensure the cron service is started
CMD ["cron", "-f"]
