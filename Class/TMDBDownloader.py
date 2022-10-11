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

    def getPoster(self, imdbid, name):
        api_response = requests.get(self.CONFIG_PATTERN.format(key=self.KEY, imdbid=imdbid)).json()
        posters = api_response['posters']
        posters_urls = []
        for poster in posters:
            poster_path = poster['file_path']
            url = "{0}{1}{2}".format(self.base_url,self.max_size,poster_path)
            posters_urls.append(url)

        r = requests.get(posters_urls[0])
        filetype = r.headers['content-type'].split('/')[-1]
        filename = 'poster_{0}.{1}'.format(name, filetype)
        with open(self.content_path + filename, 'wb') as w:
            w.write(r.content)

        return filename

    def search_downloader(self,name):

        imdb_id = self.getIMDBID(name)
        file_name = self.getPoster(imdb_id, name)
        return imdb_id, file_name



