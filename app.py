from flask import Flask, request, json , Response, render_template
from mongoDBDAL import MongoDBDAL
from TMDBDownloader import TMDBDownloader
#from secret.config import content_temp_path
from base64 import b64encode

app = Flask(__name__)
mdb = MongoDBDAL("movies", "db_host", 27017)
TMDB = TMDBDownloader()
content_temp_path= "content/"
@app.route('/')
def base():
    return Response(response=json.dumps({"Status": "UP"}),
                    status=200,
                    mimetype='application/json')

@app.route('/user/<name>')
def user(name):
    return f'<h1>Hello, {name}!</h1>'


@app.route('/search', methods=['GET', 'POST'])
def load_insert_item_html():
    if request.method == 'POST':
        movie_name = request.form['name']
        imdb_id , file_name = TMDB.search_downloader(movie_name)
        mdb.write_image_file(content_temp_path + file_name, movie_name,imdb_id)
        binary_file = mdb.read_image_file(movie_name)
        image = b64encode(binary_file).decode("utf-8")
        src = "data:image/gif;base64," + image
        return f'<img src={src}>'
    return render_template('new_form.html')

@app.route('/mongo/<search_string>', methods=['GET'])
def read(search_string):
    binary_file = mdb.read_image_file(search_string)
    image = b64encode(binary_file).decode("utf-8")
    src = "data:image/gif;base64," + image
    return f'<img src={src}>'


if __name__ == '__main__':
    app.run(debug=True, port=8080, host='0.0.0.0')