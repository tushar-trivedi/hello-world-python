from flask import Flask
from gevent.pywsgi import WSGIServer

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'HELLO World'

@app.route('/thankyou/<name>')
def thankyou_world(name):
    return f"Thankyou {name}"

if __name__ == '__main__':
    http_server = WSGIServer(("", 8080), app)
    http_server.serve_forever()
