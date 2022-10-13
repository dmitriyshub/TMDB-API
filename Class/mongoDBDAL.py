import os
import pymongo
import gridfs
import codecs
import config #this file conteins the key - shouldnt be in git, find automation sol for secrets
class MongoDBDAL:
    """
    Data Access Layer for mongodb
    in order to save big files we need to use GridFS
    mongodb solution for large binary files
    """
    def __init__(self, db_name, ip='local host',port=27017):
        """"creating client and gridfs object"""
        self.client= pymongo.MongoClient(ip, port)
        self.database = self.client[db_name]
        # Create an object of GridFs for the above database.
        self.fs = gridfs.GridFS(self.database)
    def write_image_file(self, file_name, movie_name, imdb_code):
        """
        add image file to db
        open image file saved in the FS
        rec metadata : file name, movie name, imdb code
        """
        file = file_name
        head, tail = os.path.split(file_name)
        with open(file, 'rb') as f:
            current_image = f.read()
        mongo_obj_id=self.fs.put(current_image, file_name=tail, movie_name=movie_name, imdb_code=imdb_code)
        return mongo_obj_id

    def read_image_file(self, movie_name):
        """
        search and read file from db
        saves it in wroking folder
        """
        file = self.fs.find_one({"movie_name": movie_name}).read()

        with open(movie_name + ".jpeg", 'wb') as w:
            w.write(file)
        return file

    def search_image_file_id_by_name(self, movie_name):
        """
        serach file gridfs id
        :param movie_name:
        :return:
        """
        return self.fs.find_one({"movie_name": movie_name})._id

    def del_image_file(self, movie_name):
        """
        delete movie poster
        :param movie_name:
        :return:
        """

        obj_id=self.search_image_file_id_by_name((movie_name))
        self.fs.delete(obj_id)
        output = {'Status': 'Successfully Deleted' if obj_id  else "Nothing was Deleted."}
        return output

    def update_image_file_meta_data(self,movie_name,key_to_update,val_to_update):
        """
        updtae metadata for image
        :param movie_name:
        :param key_to_update:
        :param val_to_update:
        :return:
        """
        file_id=self.search_image_file_id_by_name((movie_name))
        mycol = self.database["fs.files"]
        myquery = {"_id": file_id}
        new_values = {"$set": {key_to_update: val_to_update}}
        db_update_response=mycol.update_one(myquery, new_values)
        output = {'Status': 'Successfully Updated' if db_update_response.modified_count > 0 else "Nothing was updated."}
        return output

if __name__ == "__main__":
    """
    test module
    """
    mdb = MongoDBDAL("movies","localhost", 27017)

    #mdb.write_image_file(config.content_temp_path + "poster_matrix.jpeg", "matrix", "tt0123465")
    print(mdb.read_image_file("matrix"))
    #mdb.update_image_file_meta_data("star wars","imdb_code","no no no no no")
    #mdb.del_image_file("spiderman")