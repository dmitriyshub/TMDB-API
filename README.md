<a name="readme-top"></a>
# FLASK TMDB-API with CRUD, Docker, AWS & Terraform Cloud, GitHub Actions,
#### inspiring by https://bin.re/blog/tutorial-download-posters-with-the-movie-database-api-in-python/

## Prerequisites
1. TMDB accoount 
- with api key
2. AWS account 
- with IAM access and secret key
3. Docker Hub Account with repo
4. GitHub with Actions
- Fork the repo
- Secrets Actions: DOCKER_PASSWORD & DOCKER_USER & TF_API_TOKEN 
5. Terraform Cloud with Variable set attached to Workspace
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- create TF_API_TOKEN for GitHub
6. Set TMDB API Key in ssm parameter store to path dev/api_key as api_key=key 
7. Change Terraform variables
8. Change Docker Compose image name
9. Push to branch main
10. Apply the Terraform stage in GitHub Actions
11. Wait and copy DNS output from Terraform in GitHub Actions
- http://ec2-255-255-255-255.region.compute.amazonaws.com:8080/

## TMDB-API HTML form:
- Create:/search \
- Read:/mongo/search \
- Update:/mongo/update \
- Delete:/mongo/delete

## By URL:
- from API platform like postman or browser: \
/mongo/search/url/<search_string> method GET

- from API platform like postman: \
/mongo/delete/url/<delete_string> method DELETE


# Gonna try to make this with Terraform:

![Tux, the Linux mascot](/MD/scaling-linux-architecture.png)


<p align="right">(<a href="#readme-top">back to top</a>)</p>
