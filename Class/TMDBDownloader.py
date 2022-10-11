import os

import requests
import imdb

def size_str_to_int(x):
    return float("inf") if x == 'original' else int(x[1:])

class TMDBDownloader:
    content_path = "./content/"

    def __init__(self):
        self.KEY = os.getenv('api_key') # api key
        self.CONFIG_PATTERN = 'http://api.themoviedb.org/3/configuration?api_key={key}' #url format
        self.url = self.CONFIG_PATTERN.format(key=self.KEY) # format key to url
        self.r = requests.get(self.url) # send request
        self.config = self.r.json() # response to json

        self.base_url = self.config['images']['base_url'] # # get urls of the posters
        self.sizes = self.config['images']['poster_sizes'] # get all poster sizes
        self.max_size = max(self.sizes, key=size_str_to_int) # get max size poster

    def getIMDBID(self, name):
        '''
        get the movie id from imdb
        :param name: name of the movie
        :return: first movie ID
        '''
        ob = imdb.IMDb()
        search = ob.search_movie(name)
        return "tt" + str(search[0].movieID)