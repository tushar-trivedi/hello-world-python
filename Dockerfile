# Use a Python base image
FROM python:3.9-slim


COPY /src /app
COPY requirements.txt /app
WORKDIR /app

RUN pip3 install --upgrade --no-cache-dir -r ./requirements.txt 

EXPOSE 5000

# Command to run the application
CMD ["python", "-u","app.py"]
