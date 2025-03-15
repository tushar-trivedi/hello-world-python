from flask import Flask, render_template
from gevent.pywsgi import WSGIServer

app = Flask(__name__, template_folder="templates")

@app.route('/')
def hello_world():
    return render_template('index.html', message='Hello World')

@app.route('/thankyou/<name>')
def thank_you(name):
    return render_template('index.html', message=f'Thank You, {name}!')

if __name__ == '__main__':
    http_server = WSGIServer(("", 8080), app)
    http_server.serve_forever()
