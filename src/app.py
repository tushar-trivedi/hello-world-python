from flask import Flask
from gevent.pywsgi import WSGIServer

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'HELLO WORLD!'

if __name__ == '__main__':
    http_server = WSGIServer(("", 8080), app)
    http_server.serve_forever()
