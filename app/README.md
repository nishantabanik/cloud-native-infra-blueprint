# User Management Portal

This is a minimal web application written using python flask, to demonstrate a micro-service running in a containerized environment.

## How to run locally
```bash
    cd app
    pip install -r requirements.txt
    python app.py
```

## How to build via Docker
```bash
    cd app
    docker build -t user-portal:1.0.0 .
```

## Details about the app

The application has the following endpoints : 
* `/users` - Shows a list of users from the database, accessed via the `User Dashboard` tab after login
* `/admin` - Allows adding users for `admin` user, accessed via the `User Management` tab after admin login
* `/logout` - Allows a user to logout
* `/login` - Allows user to login, accessed vi the home page

Note: The application fetches database credentials from the AWS secrets manager. 
A secret manager entry with the name `database_credentials` is expected in the desired AWS region. 
Please check `config.py` for more details.

## Testing

For Administrator access, please use `admin:admin` after running the `db.sql` file under `schema` folder.