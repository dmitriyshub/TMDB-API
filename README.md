<a name="readme-top"></a>
# FLASK TMDB-API with CRUD, Docker, AWS & Terraform Cloud, GitHub Actions,
#### inspiring by https://bin.re/blog/tutorial-download-posters-with-the-movie-database-api-in-python/

### Prerequisites
1. TMDB account 
- With API key
2. AWS account 
- With IAM access and secret key
3. Docker Hub Account with repo
4. GitHub with Actions
- Fork the repo
- Secrets Actions: DOCKER_PASSWORD & DOCKER_USER & TF_API_TOKEN 
5. Terraform Cloud with Variable set attached to Workspace
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- Create TF_API_TOKEN for GitHub
6. Set TMDB API Key in ssm parameter store to path dev/api_key as api_key=key 
7. Change Terraform variables
8. Change Docker Compose image name
9. Push to branch main
10. Apply the Terraform stage in GitHub Actions
11. Wait and copy DNS output from Terraform in GitHub Actions
- http://ec2-255-255-255-255.region.compute.amazonaws.com:8080/

### My Moduls
1. TMDBDownloader - Use the IMDB-API to get an poster image
2. MongoDB CRUD - Use gridFS package for large object to store images
3. Flask Web Server for my CRUD API and also a web API

### HTML form:

1. Create:/create 
- This endpoint:
- Searching for poster by name and store him in mongodb
- If exist in mongoDB then retrieve poster from Database

2. Read:/read 
- Read posters from mongoDB
3. Update:/update 
- Update poster metadata
4. Delete:/delete
- Delete poster from Database

### By url:
- from API platform like postman or browser:
- /create/url/<search_string>
- /read/url/<search_string>
- /delete/url/<delete_string>
- /update/url/<update_string> in proccess



# Gonna try to make this with Terraform:


![Tux, the Linux mascot](/images/scaling-linux-architecture.png)


<p align="right">(<a href="#readme-top">back to top</a>)</p>
