from pymongo import MongoClient
import json
import gridfs
#from bson import Regex
from bson import ObjectId


class MongoDriver:

    def __init__(self,ip,port,database,collection):
        # Connect to the server with the hostName and portNumber.
        self.mongo = MongoClient(ip, port, maxPoolSize=50)

        # Connect to the Database where the images will be stored.
        self.database = self.mongo[database]

        # Connect to the Collection in the Database
        self.collection = self.database[collection]

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



    def read_image(self,filename):
        '''
        cRud
        read binary image
        :param filename:
        :return: binary image
        '''

        image_bin = self.fs.get_last_version(filename).read()
        return image_bin

    def save_image(self, image_bin, imagename='image.jpeg'):
        '''
        cRud
        save image on disk
        :param image_bin: binary image
        :param imagename: name of the image

        '''
        with open(f'{imagename}.jpeg', 'wb') as outfile:
            outfile.write(image_bin)  # Write your data

    def update_image(self,filename, newfilename):
        # TODO !
        '''
        crUd
        :param filename:
        :return:
        '''
        # a = self.collection.name
        # self.collection.update_one(ObjectId(image_id))

        file_name_kv = {'filename' : filename}
        new_file_name_kv = {'$set' : {'filename' : newfilename}}
        self.collection.update_one(file_name_kv, new_file_name_kv)


    def delete_image_id(self,file_id):
        '''
        cruD
        delete image from database
        :param file_id:
        :return:
        '''
        self.fs.delete(file_id)

    def delete_image_name(self,filename):
        # TODO
        '''
        cruD
        :param filename:
        :return:
        '''
        file_id = self.find_image_id(filename)
        self.collection.delete_one({'_id': file_id})

    def get_collections(self):
        '''
        list collections name
        :return: str
        '''
        client = self.mongo
        d = dict((db, [collection for collection in client[db].list_collection_names()])
                 for db in client.list_database_names())
        return json.dumps(d)

    def find_image_id(self,filename):
        '''
        find the image id by image name
        :param filename:
        :return: file id
        '''
        for x in self.fs.find({'filename': filename}):
            file_id = x._id
            return file_id

    def get_image(self, filename):
        #self.fs.get_last_version(filename).read()
        return self.fs.get(filename)

    def find_images(self, filename):
        data = self.fs.get_last_version(filename).read()
        return data
        # for f in self.fs.find({'filename': Regex(r'.*\.(png|jpg)')}):
        #     data = f.read()
        #     return data

if __name__ == "__main__":
    test = MongoDriver("localhost", 27017, "movie_posters", "fs.files") # init object

    #test.add_image('poster_matrix.jpeg') # add image to db

    test2 = test.get_collections() # get collection names
    print(test2)

    file_id = test.find_image_id('poster_matrix.jpeg') # get file id by name

    test.delete_image_name('XXX')

    #image = test.read_image('poster_matrix.jpeg') # save bytearray of image

    #test.save_image(image, imagename='poster_matrix.jpeg') # save image to disk

    #test.update_image('poster_fight club.jpeg', 'XXX') # update image name

    #test.update_image()


    #test3 = test.get_image()
    #print(test3)
    #a = test.find_images('image')
    # a = test.get_image(file_id)
    # print(a)
    # a.write('aaaa')



