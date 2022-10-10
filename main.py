#!/usr/bin/env python
import requests
import os
from dotenv import load_dotenv

def configure():
    load_dotenv()

def get_data():
    KEY = os.getenv('api_key')
    CONFIG_PATTERN = 'http://api.themoviedb.org/3/configuration?api_key={key}'
    url = CONFIG_PATTERN.format(key=KEY)
    r = requests.get(url)
    config = r.json()
    return config

def main():
    configure()
    api_data = get_data()
    print(api_data)
    return api_data

if __name__ == '__main__':

    main()
