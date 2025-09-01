# User Portal

This repository consists of the code for a sample web application for user management and the IaC to host it in AWS. 

### Repo structure
* `app` - Contains application code with the docker file
* `chart` - Contains the helm chart to deploy the application to the kubernetes cluster
* `datasets` - Contains a sample data set of users to load into the database
* `schema` - Contains the database schema for the application
* `serverless` - Contains the code for a lambda function that imports user data from the S3 bucket
* `terraform` - Contains the IaC for provisioning the AWS infrastructure where the application will be hosted