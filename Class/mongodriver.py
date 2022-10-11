from pymongo import MongoClient
import json
import gridfs


###################################################

class MongoDriver:

    def __init__(self):
        # Connect to the server with the hostName and portNumber.
        self.mongo = MongoClient("localhost", 27017, maxPoolSize=50)

        # Connect to the Database where the images will be stored.
        self.database = self.mongo['movie_posters']

        # Create an object of GridFs for the above database.
        self.fs = gridfs.GridFS(self.database)

    def __str__(self):
        print(self.mongo.list_database_names())

    def add_image(self):
        # define an image object with the location. TODO add movie name from imdb from the api class
        image_name = "content\poster_terminal.jpeg"
        # Open the image in read-only format.
        with open(image_name, 'rb') as f:
            contents = f.read()
            # store/put the image via GridFs object.
            self.fs.put(contents, filename="image")
    def read_image(self):
        self.database.fi

    def get_tables(self):
        client = self.mongo
        d = dict((db, [collection for collection in client[db].list_collection_names()])
                 for db in client.list_database_names())
        return json.dumps(d)

    def get_image(self):
        client = self.mongo
        db = client.localhost
        collection = db['movie_posters']
        cursor = collection

        a = []
        print(cursor)




if __name__ == "__main__":
    test = MongoDriver()
    #test.add_image()
    test2 = test.get_tables()
    print(test2)
    test3 = test.get_image()
    print(test3)
