#!/usr/bin/env python
import requests
import os
from dotenv import load_dotenv
from imdb_id import imdb_movie_id as get_id

def configure():
    load_dotenv()

def get_data():
    '''
    retrieve api data
    :return: api data in json format
    '''
    KEY = os.getenv('api_key')
    CONFIG_PATTERN = 'http://api.themoviedb.org/3/configuration?api_key={key}'
    url = CONFIG_PATTERN.format(key=KEY)
    r = requests.get(url)
    config = r.json()
    return config

def size_str_to_int(x):
    return float("inf") if x == 'original' else int(x[1:])

def use_data(config):
    '''

    :param config: json api response
    :return: the biggest size available
    '''
    base_url = config['images']['base_url']
    sizes = config['images']['poster_sizes']
    max_size = max(sizes, key=size_str_to_int)
    return max_size, base_url

def available_poster():
    KEY = os.getenv('api_key')
    IMG_PATTERN = 'http://api.themoviedb.org/3/movie/{imdbid}/images?api_key={key}'
    r = requests.get(IMG_PATTERN.format(key=KEY, imdbid='tt0133093'))
    api_response = r.json()
    return api_response

def poster_urls(api_response,base_url,max_size):
    posters = api_response['posters']
    poster_urls = []
    for poster in posters:
        rel_path = poster['file_path']
        url = "{0}{1}{2}".format(base_url, max_size, rel_path)
        poster_urls.append(url)
        return poster_urls

def download_poster(poster_url):
    for nr, url in enumerate(poster_url):
        r = requests.get(url)
        filetype = r.headers['content-type'].split('/')[-1]
        filename = 'poster_{0}.{1}'.format(nr + 1, filetype)
        with open(filename, 'wb') as w:
            w.write(r.content)

def main():
    configure()
    # TODO: adding functionality with movie id
    # movie_name = input("which movie?")
    # movie_id = get_id(movie_name)
    # print(movie_id)

    max_size, base_url = use_data(get_data())
    poster_url = poster_urls(available_poster(),base_url,max_size)
    download_poster(poster_url)


if __name__ == '__main__':

    main()
