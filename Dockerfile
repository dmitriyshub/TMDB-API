FROM debian
# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

WORKDIR /app
COPY . /app
RUN pip3 install -r requirements.txt


EXPOSE 8080

CMD ["python3","app.py"]
