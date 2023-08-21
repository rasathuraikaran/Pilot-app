# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app
from flask import Flask, request, jsonify
from ml_model import train_and_predict
import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate("key.json")
firebase_admin.initialize_app(cred)

app = Flask(__name__)

@app.route('/predict_level', methods=['POST'])
def predict_level():
    data = request.get_json()

    question = data['question']

    predicted_level = train_and_predict(question)

    response = {'predicted_level': predicted_level}
    return jsonify(response)


@app.route('/k', methods=['GET'])
def predict_level1():

    return "hi this srk"



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

# initialize_app()
#
#
# @https_fn.on_request()
# def on_request_example(req: https_fn.Request) -> https_fn.Response:
#     return https_fn.Response("Hello world!")