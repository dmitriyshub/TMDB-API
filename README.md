# TMDB-API with CRUD
# inspiring by https://bin.re/blog/tutorial-download-posters-with-the-movie-database-api-in-python/
Setting `app.config['SERVER_NAME'] = '0.0.0.0:5000'`
is not the same as calling `app.run(host='0.0.0.0', port=5000)`.
If you set `SERVER_NAME` flask thinks its name is `0.0.0.0:5000`
and you will have the below problem.

# Start the app

```commandline
git clone https://github.com/dmitriyshub/TMDB-API.git
...
docker-compose up -d
...

```

for external ip allow ufw rule:

```commandline
sudo ufw enable
sudo ufw allow 5000/tcp //allow the server to handle the request on port 5000
```

Can access to 127.0.0.1:8080 (or external ip) from browser 

Create:/search \
Read:/mongo/search \
Update:/mongo/update \
Delete:/mongo/delete

by url:
from API platform like postman or browser: \
/mongo/search/url/<search_string> method GET

from API platform like postman: \
/mongo/delete/url/<delete_string> method DELETE
