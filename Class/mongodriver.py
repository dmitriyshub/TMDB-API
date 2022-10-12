from pymongo import MongoClient
import json
import gridfs
from bson import Regex


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

    def add_image(self,filename):
        '''
        Crud
        add image to database
        :param filename: filename prefix and sufix
        :return:
        '''
        # define an image object with the location. TODO add movie name from imdb from the api class
        image_name = f"content\{filename}"
        # Open the image in read-only format.
        with open(image_name, 'rb') as f:
            contents = f.read()
            # store/put the image via GridFs object.
            self.fs.put(contents, filename=filename)


    def delete_image(self,file_id):
        '''
        cruD
        delete image from database
        :param file_id:
        :return:
        '''
        self.fs.delete(file_id)


    def read_image(self):
        # TODO ask omri about this method
        a = self.database.fi
        return a

    def get_collections(self):
        client = self.mongo
        d = dict((db, [collection for collection in client[db].list_collection_names()])
                 for db in client.list_database_names())
        return json.dumps(d)

    def find_image_id(self,filename):
        '''

        :param filename:
        :return: file id
        '''
        for x in self.fs.find({'filename': filename}):
            file_id = x._id
            return file_id


    def get_image(self, filename):
        #self.fs.get_last_version(filename).read()
        self.fs.get(filename)

        # client = self.mongo
        # db = client.localhost
        # collection = db['movie_posters']
        # cursor = collection
        #
        # a = []
        # print(cursor)
    def find_images(self, filename):
        data = self.fs.get_last_version(filename).read()
        return data
        # for f in self.fs.find({'filename': Regex(r'.*\.(png|jpg)')}):
        #     data = f.read()
        #     return data




if __name__ == "__main__":
    test = MongoDriver()
    test.add_image('poster_matrix.jpeg')
    test2 = test.get_collections()
    print(test2)
    file_id = test.find_image_id('poster_matrix.jpeg')
    #test.delete_image(file_id)

    #test3 = test.get_image()
    #print(test3)
    #a = test.find_images('image')
    #test.get_image('6345e0538734846ce0afe743')
