from pymongo import MongoClient
import gridfs


###################################################

class MongoDriver:

    def __init__(self):
        # Connect to the server with the hostName and portNumber.
        self.mongo = MongoClient("localhost", 27017)

        # Connect to the Database where the images will be stored.
        self.database = self.mongo['movie_posters']

        # Create an object of GridFs for the above database.
        self.fs = gridfs.GridFS(self.database)

    def __str__(self):
        print(self.mongo.list_database_names())

    def add_image(self):
        # define an image object with the location. TODO add movie name from imdb from the api class
        image_name = "content\poster_fight club.jpeg"
        # Open the image in read-only format.
        with open(image_name, 'rb') as f:
            contents = f.read()
            # store/put the image via GridFs object.
            self.fs.put(contents, filename="image")
    def read_image(self):
        self.database.fi




if __name__ == "__main__":
    test = MongoDriver()
    test.add_image()
