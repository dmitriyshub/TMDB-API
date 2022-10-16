import requests
import imdb
#from secret.config import TMDB_API_Key_v3_auth # old key authentication
import os
from dotenv import load_dotenv

def configure():
    load_dotenv('secret/.env')

def size_str_to_int(x):
    return float("inf") if x == 'original' else int(x[1:])

class TMDBDownloader:
    content_path = "content/"

    def __init__(self):
        configure()
        self.CONFIG_PATTERN = 'http://api.themoviedb.org/3/configuration?api_key={key}' #url format
        self.IMG_PATTERN = 'http://api.themoviedb.org/3/movie/{imdbid}/images?api_key={key}'
        #self.KEY = TMDB_API_Key_v3_auth # api key
        self.KEY = os.getenv('api_key') # api key
        self.url = self.CONFIG_PATTERN.format(key=self.KEY) # format key to url
        self.r = requests.get(self.url) # send request
        self.config = self.r.json() # response to json
        self.base_url = self.config['images']['base_url'] # # get urls of the posters
        self.sizes = self.config['images']['poster_sizes'] # get all poster sizes
        self.max_size = max(self.sizes, key=size_str_to_int) # get max size poster
        self.name = ""
        self.imdb_id=""


    def getIMDBID(self, name):
        '''
        get the movie id from imdb
        :param name: name of the movie
        :return: first movie ID
        '''
        list_ids = []
        ia = imdb.IMDb()
        search = ia.search_movie(name)

        for i in range(len(search)):
            # getting the id
            id = search[i].movieID
            list_ids.append(id)
        imdb_id = "tt" + str(list_ids[0])
        return imdb_id

    def getPoster(self, imdbid):
        api_response = requests.get(self.IMG_PATTERN.format(key=self.KEY, imdbid=imdbid)).json()
        posters = api_response['posters']
        posters_urls = []
        for poster in posters:
            poster_path = poster['file_path']
            url = "{0}{1}{2}".format(self.base_url,self.max_size,poster_path)
            posters_urls.append(url)
        return posters_urls

    def getPosterFile(self, imdb_id, name):
        posters_urls = self.getPoster(imdb_id)
        r = requests.get(posters_urls[0])
        filetype = r.headers['content-type'].split('/')[-1]
        filename = 'poster_{0}.{1}'.format(name, filetype)
        with open(self.content_path + filename, 'wb') as w:
            w.write(r.content)
        return filename

        #return filename

    def search_downloader(self,name):

        imdb_id = self.getIMDBID(name)
        file_name = self.getPosterFile(imdb_id, name)
        return imdb_id, file_name

def main():

    connector = TMDBDownloader()
    connector.search_downloader("spiderman")

if __name__ == '__main__':
    '''
    test TMDB module
    '''
    main()

