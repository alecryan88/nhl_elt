# Configuring a Lambda Function

The extract component of the project is Python code pacakaged up in a docker image that gets executed by calling an AWS lambda function. 

This is a very simple and cost-effective way to pump data into S3 where it can be loaded directly into your Snowflake warehouse.



## Setup 
There are a few simple steps involved in getting up and running with this portion of the project:

1. Create a fresh python virtual environment. Mine is called `venv`. 
``` sh
python3 -m venv venv 
```
2. Activate your newly created virtual environment by running: 
``` sh
python3 venv/bin/activate
```

3. Pip install any dependencies that are required for the lambda function. 
```sh
pip install requests
```

4. Freeze the requirements.txt file. This will be used later when building the docker image: 
```sh
pip3 freeze > requirements.txt
```
5. Finally, you'll want to create a `.env` file that can be used for testing your lambda function locally: 
```sh
touch .env
```
6. Inside of the `.env` file, you need to add AWS credentials specific to your account. These will be used for lambda function testing only:
```sh
#.env
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
```

## Build and Test Image
This section is relevant for creating the docker images that are run using a lambda functions in AWS. There are a series of steps required to build the image and test the function as outlined [here](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html) in the AWS Lambda docs: 

1. Build the docker image for the lambda function:
``` sh 
docker build -t nhl_elt .   
```
2. Run a container from the docker image: 
``` sh
docker run --env-file .env -p 9000:8080 nhl_elt
```
3. In a seperate terminal, test the lambda function:
```sh
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```
You should see the lambda function run successfully.


## Push Image to Elastic Container Registry (ECR) 
Once the lambda function is run succesfully and the data looks as expected in S3, you can push the image to ECR where it can be deployed by a lambda function. There are a few steps required to do this:
1. Create a repository in ECR where you will push your image
2. Configure the AWS user with the correct permissions for working 
3. Export your `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` and `AWS_REGISTRY_ID` as environment variables. You can find your `AWS_REGISTRY_ID` in the URL or by clicking view push commands in ECR.
```sh
#~/.bash_profile
EXPORT AWS_ACCESS_KEY_ID=
EXPORT AWS_SECRET_ACCESS_KEY=
EXPORT AWS_REGISTRY_ID=
EXPORT AWS_REGION=
```
5. Login to ECR:
```sh
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com
```
6. Tag the docker image that we've built previously:
```sh
docker tag nhl_elt:latest $AWS_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/nhl_elt:latest
```

7. Finally, push the image to ECR. Now that the image is in ECR, we can create the lambda function that will run the image.
```sh
docker push $AWS_REGISTRY_ID.dkr.ecr.$AWS_REGION.amazonaws.com/nhl_elt:latest
```