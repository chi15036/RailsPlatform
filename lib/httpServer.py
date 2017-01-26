#!/usr/bin/env python
# encoding=utf-8
import sys
import Taiba
from flask import Flask, request
from threading import Thread


app = Flask(__name__)

class CutWord():

    def __init__(self):
        # Initial work2Vec
        self.count = 0;

    def cut(self, message):
        return Taiba.lcut(message, CRF=True)

    def stop(self):
        self.count = 0;

@app.route('/cut', methods=['GET'])
def cutWord():
    if request.method == 'GET':
        message = request.args.get('message')
        seg = engine.cut(message)
        result = repr([x.encode('utf-8') for x in seg]).decode('string-escape')
        return result

@app.route('/stop_engine')
def stop_engine():
    func = request.environ.get('werkzqug.server.shutdown')
    if func is None:
        raise RuntimeError('werkzeug.server.shutdown')
    func()
    engine.stop()
    sys.exit()
    return

@app.errorhandler(500)
def internal_server_error(error):
    app.logger.error('Server Error: %s', (error))
    return render_template('500.htm'), 500

@app.errorhandler(Exception)
def unhandled_exception(e):
    app.logger.error('Unhandled Exception: %s', (e))
    return render_template('500.htm'), 500


if __name__ == '__main__':

    engine = CutWord()
    app.run(host='0.0.0.0', threaded=True, debug=True)
