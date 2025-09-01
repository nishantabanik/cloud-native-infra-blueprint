import hashlib
import uuid

import mysql.connector

from config import get_db_credentials

db_credentials = get_db_credentials()

config = {
    'user': db_credentials['user'],
    'password': db_credentials['password'],
    'host': db_credentials['host'],
    'database': db_credentials['database'],
    'raise_on_warnings': True
}


def get_connection():
    cnx = mysql.connector.connect(**config)
    return cnx

def get_users():
    _conn = get_connection()
    _c = _conn.cursor()

    _c.execute("SELECT id, title, firstname, lastname, status, username, age, created_at FROM users;")
    result = _c.fetchall()

    _conn.close()
    
    return result

def list_users():
    _conn = get_connection()
    _c = _conn.cursor()

    _c.execute("SELECT * FROM users;")
    result = [x[5] for x in _c.fetchall()]

    _conn.close()

    return result

def verify(username, pw):
    _conn = get_connection()
    _c = _conn.cursor()

    _c.execute("SELECT password FROM users WHERE username = '" + username + "';")
    result = _c.fetchone()[0] == hashlib.sha256(pw.encode()).hexdigest()
    
    _conn.close()

    return result

def delete_user_from_db(username):
    _conn = get_connection()
    _c = _conn.cursor()
    _c.execute("DELETE FROM users WHERE username = '" + username + "';")

    _conn.commit()
    _conn.close()

def add_user(title, firstname, lastname, username, pw, age):
    _conn = get_connection()
    _c = _conn.cursor()

    _c.execute(
        "INSERT INTO users(title,firstname,lastname,status,username,password,age) values(%s, %s, %s, %s, %s, %s, %s)",
        (
            title,
            firstname,
            lastname,
            1,
            username.lower(),
            hashlib.sha256(pw.encode()).hexdigest(),
            age
        )
    )
    
    _conn.commit()
    _conn.close()


if __name__ == "__main__":
    print(list_users())
