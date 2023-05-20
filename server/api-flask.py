from flask import Flask, send_file, request

from flask_restful import Api, Resource, reqparse
from graph import *
import numpy as np
import random
import os
import tracemalloc
tracemalloc.start()


app = Flask(__name__)
api = Api(app)


def send_graph(x, y, approx='no', label='Значения',
               xlabel='x', ylabel='y', x_scale=0, y_scale=0, use_dark=1):
    filename = use_graph(x, y, approx=approx, label=label,
                         xlabel=xlabel, ylabel=ylabel, x_scale=x_scale, y_scale=y_scale, use_dark=use_dark)
    res = send_file(filename, mimetype="image/png")
    os.remove(filename)
    return res


class Quote(Resource):

    @app.route('/get_graph')
    def get_image():
        try:
            x = np.array(list(map(float, request.args.getlist('x'))))
            y = np.array(list(map(float, request.args.getlist('y'))))
            approx = str(request.args.get("approx"))
            label = str(request.args.get("label"))
            xlabel = str(request.args.get("xlabel"))
            ylabel = str(request.args.get("ylabel"))
            x_scale = str(request.args.get("x_scale"))
            y_scale = str(request.args.get("y_scale"))
            use_dark = str(request.args.get("use_dark"))
            res = send_graph(x, y, approx=approx, label=label,
                             xlabel=xlabel, ylabel=ylabel, x_scale=x_scale, y_scale=y_scale, use_dark=use_dark)
            del x, y, approx, label, xlabel, ylabel, x_scale, y_scale, use_dark
        except:
            res = abort(400, 'Record not found')
        snapshot = tracemalloc.take_snapshot()
        top_stats = snapshot.statistics('lineno')

        print("[ Top 10 ]")
        for stat in top_stats[:10]:
            print(stat)
        return res


api.add_resource(Quote, "/get_graph")

if __name__ == '__main__':
    # app.run(debug=True)
    from waitress import serve
    serve(app, host="<your-ip>", port=8888)
