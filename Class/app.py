from flask import Flask, request, json , Response
from mongoDBDAL import MongoDBDAL
app = Flask(__name__)


@app.route('/')
def base():
    return Response(response=json.dumps({"Status": "UP"}),
                    status=200,
                    mimetype='application/json')


@app.route('/mongodb', methods=['GET'])
def mongo_read():
    data = request.json
    filename = data['movie_name']
    if data is None or data == {}:
        return Response(response=json.dumps({"Error": "Please provide connection information"}),
                        status=400,
                        mimetype='application/json')
    obj1 = MongoDBDAL("movies", ip='localhost', port=27017)
    response = obj1.read_image_file(filename)
    json_str = json.dumps({'message': response.decode()})

    return Response(response=json.dumps(response),
                    status=200,
                    mimetype='application/json')



if __name__ == '__main__':
    app.run(debug=True, port=5000, host='0.0.0.0')