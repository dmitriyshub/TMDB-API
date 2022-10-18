from flask import Flask, request, json , Response, render_template #, send_file
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

@app.route('/create', methods=['GET', 'POST'])
def search_and_download():
    if request.method == 'POST':
        movie_name = request.form['name']
        binary_file = mdb.read_image_file(movie_name)
        if binary_file == None:
            try:
                imdb_id, file_name = TMDB.search_downloader(movie_name)
            except:
                return render_template('new_form.html')
            mdb.write_image_file(content_temp_path + file_name, movie_name, imdb_id)
            binary_file = mdb.read_image_file(movie_name)
            image = b64encode(binary_file).decode("utf-8")
            src = "data:image/gif;base64," + image
            return f'<img src={src}>'
        else:
            image = b64encode(binary_file).decode("utf-8")
            src = "data:image/gif;base64," + image
            return f'<img src={src}>'

    return render_template('new_form.html')

@app.route('/create/url/<search_string>', methods=['GET', 'POST'])
def search_and_download_url(search_string):
    if request.method == 'POST' or request.method == 'GET':

        binary_file = mdb.read_image_file(search_string)
        if binary_file == None:
            try:
                imdb_id, file_name = TMDB.search_downloader(search_string)
            except:
                return Response(response=json.dumps({"Status": "API Error Try Again"}),
                                status=403,
                                mimetype='application/json')
            mdb.write_image_file(content_temp_path + file_name, search_string, imdb_id)
            binary_file = mdb.read_image_file(search_string)
            image = b64encode(binary_file).decode("utf-8")
            src = "data:image/gif;base64," + image
            return f'<img src={src}>'
        else:
            image = b64encode(binary_file).decode("utf-8")
            src = "data:image/gif;base64," + image
            return f'<img src={src}>'



@app.route('/read', methods=['GET','POST'])
def read_form():
    if request.method == 'POST':
        search_string = request.form['name']
        binary_file = mdb.read_image_file(search_string)
        if binary_file != None:
            image = b64encode(binary_file).decode("utf-8")
            src = "data:image/gif;base64," + image
            return f'<img src={src}>'
    return render_template('read_form.html')

@app.route('/read/url/<search_string>', methods=['GET'])
def read_url(search_string):
    binary_file = mdb.read_image_file(search_string)
    if binary_file != None:
        image = b64encode(binary_file).decode("utf-8")
        src = "data:image/gif;base64," + image
        return f'<img src={src}>'
    return Response(response=json.dumps({"Status": "Not Found"}),
                    status=404,
                    mimetype='application/json')

@app.route('/delete',methods=['GET','POST'])
def delete_form():
    if request.method == 'POST':
        movie_name = request.form['name']
        delete_movie = mdb.del_image_file(movie_name)
        if delete_movie['Status'] == 'Successfully Deleted':
            return Response(response=json.dumps(delete_movie),
                            status=200,
                            mimetype='application/json')
        elif delete_movie['Status'] == 'Nothing was Deleted':
            return Response(response=json.dumps(delete_movie),
                            status=404,
                            mimetype='application/json')
        elif delete_movie['Status'] == 'No such file':
            return Response(response=json.dumps({"Status": "No such file"}),
                            status=404,
                            mimetype='application/json')
        else:
            return Response(response=json.dumps({"Status": "Something went Wrong"}),
                            status=404,
                            mimetype='application/json')

    return render_template('delete_form.html')

@app.route('/delete/url/<delete_string>', methods=['GET'])
def delete_url(delete_string):
    delete_movie = mdb.del_image_file(delete_string)
    if delete_movie['Status'] == 'Successfully Deleted':
        return Response(response=json.dumps(delete_movie),
                        status=200,
                        mimetype='application/json')
    elif delete_movie['Status'] == 'Nothing was Deleted':
        return Response(response=json.dumps(delete_movie),
                        status=404,
                        mimetype='application/json')
    elif delete_movie['Status'] == 'No such file':
        return Response(response=json.dumps({"Status": "No such file"}),
                        status=404,
                        mimetype='application/json')
    else:
        return Response(response=json.dumps({"Status": "Something went Wrong"}),
                        status=404,
                        mimetype='application/json')

@app.route('/update', methods=['GET', 'POST', 'PUT'])
def update_form():
    if request.method == 'POST' or request.method == 'PUT':
        movie_name = request.form['name']
        key_to_update = request.form['key']
        value_to_update = request.form['value']
        update_movie = mdb.update_image_file_meta_data(movie_name,key_to_update,value_to_update)
        if update_movie['Status'] == 'Successfully Updated':
            return Response(response=json.dumps(update_movie),
                            status=200,
                            mimetype='application/json')

        elif update_movie['Status'] == 'Nothing was Updated':
            return Response(response=json.dumps(update_movie),
                            status=404,
                            mimetype='application/json')

        elif update_movie['Status'] == 'No such file':
            return Response(response=json.dumps({"Status": "No such file"}),
                            status=404,
                            mimetype='application/json')

        else:
            return Response(response=json.dumps({"Status": "Something went Wrong"}),
                            status=404,
                            mimetype='application/json')

    return render_template('update_form.html')




if __name__ == '__main__':
    app.run(debug=True, port=8080, host='0.0.0.0')


















    # @app.route('/create/api', methods=['GET', 'POST'])
    # def search_and_download_api():
    #     data = request.json
    #     movie_name = data['name']
    #     binary_file = mdb.read_image_file(movie_name)
    #     if binary_file == None:
    #         try:
    #             imdb_id, file_name = TMDB.search_downloader(movie_name)
    #         except:
    #             return Response(response=json.dumps({"Status": "API Error Try Again"}),
    #                             status=403,
    #                             mimetype='application/json')
    #         mdb.write_image_file(content_temp_path + file_name, movie_name, imdb_id)
    #         binary_file = mdb.read_image_file(movie_name)
    #         image = b64encode(binary_file).decode("utf-8")
    #
    #         return send_file(content_temp_path+ file_name, mimetype='image/gif')
    #     else:
    #         try:
    #             imdb_id, file_name = TMDB.search_downloader(movie_name)
    #         except:
    #             return Response(response=json.dumps({"Status": "API Error Try Again"}),
    #                             status=403,
    #                             mimetype='application/json')
    #         binary_file = mdb.read_image_file(movie_name)
    #         image = b64encode(binary_file).decode("utf-8")
    #         return send_file(content_temp_path+ file_name, mimetype='image/gif')