### Install and run postgres

### Install Fedora's Docker implementation

```sh
sudo dnf groupinstall 'Development Tools' 'Development Libraries'
sudo dnf install postgresql
```

Do we need the Development tools etc anymore?
groupinstall 'Development Tools' installs things like gcc,'Development Libraries' too, and is my recommendation.

Create a project directory and put the below in its docker-compose.yml file.

```yaml
version: "3.8"

services:
  db:
    image: postgres
    container_name: db
    restart: always
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - appdb:/var/lib/postgresql/data:Z
    stdin_open: true
    tty: true
    ports:
      - 5432:5432
  pgadmin:
    image: dpage/pgadmin4
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: jason@jasonbrunelle.com
      PGADMIN_DEFAULT_PASSWORD: example
    ports:
      - 8080:80
volumes:
  appdb:
```
Start the containers (--build makes sure it rebuilds the containers if anything changed)

```sh
docker-compose up -d --build
```

```sh
docker exec -it db /bin/bash
```

Or if you just need psql

```sh
docker exec -it db /usr/bin/psql -U postgres
```

Create a role for our dev user

```sql
  CREATE ROLE dev WITH SUPERUSER CREATEROLE CREATEDB LOGIN PASSWORD '123456';
  exit
```

From here you should not need to login to psql via docker anymore. Use native psql on host.

### Connect to Database instance

```sh
psql -U dev -W -d postgres
```

### Create and connect to database

```sql
  CREATE DATABASE project_name;
  \c project_name;
```
### create a test table

```sql
CREATE TABLE test (
  id SERIAL,
  val1 VARCHAR(20),
  val2 VARCHAR(20)
);
```

Create a role for our app

```sql
  CREATE ROLE app WITH LOGIN PASSWORD '654321';
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app;
  GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app;
  CREATE SCHEMA test;
  ALTER DEFAULT PRIVILEGES IN SCHEMA test GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app;
```
You'll need to go back through these grants each time a new relation is created.

### Insert some dummy data for testing

```sql
INSERT INTO test VALUES(default, 'Hi', 'There');
```

## Create quick test app

### Test programmatically

<details>
  <summary>With node</summary>

Add a Dockerfile
```
FROM node:latest #docker pull node:18.9.0 latest successful test

WORKDIR /app

COPY ./app/package.json .

RUN npm i
```

build your image

```sh
docker build -t pyapp .
```

add your app to your docker-compose.yml in the services section
```yaml
  app:
    image: nodeapp
    container_name: app
    restart: always
    volumes:
      - ./app:/app:Z
      - ./app/node_modules
    stdin_open: true
    tty: true
    environment:
      PGUSER: app
      PGPASSWORD: 654321
      PGHOST: db
      PGPORT: 5432
      PGDATABASE: project_name
      DATABASE_URL: postgres://${PGUSER}@${PGHOST}:${PGPORT}/${PGDATABASE}
```

This line:
- ./app/node_modules
Ensures that the above volume does not override node_modules folder which is not passed as a volume but is instead actually installed in the image

Copy your package.json
```json
{
  "name": "app",
  "version": "1.0.0",
  "description": "",
  "main": "app.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "pg": "^8.8.0"
  }
}
```

Create your javascript file

```javascript
const { Pool } = require("pg");

// If you've set environment variables this is not needed
// const connectionString = 'postgresql://app:123456@localhost:5432/project_name'

const pool = new Pool({
  // If you've set environment variables this is not needed
  // connectionString,
});

(async () => {
  const client = await pool.connect();
  try {
    let res = await client.query("SELECT * FROM test");
    console.log(res.rows[0]);
    res = await client.query(
      "INSERT INTO test VALUES (default, $1, $2) RETURNING *", //or RETURNING id
      ["Hi", "Back"]
    );
    console.log(res.rows[0]);
  } catch (err) {
    console.error(err);
  } finally {
    client.release();
  }
})().finally(() => pool.end());
```

Restart everything
```sh
docker-compose down
docker-compose up -d --build
```

try running your app
```sh
docker exec -it nodeapp /bin/bash
node app.js
```

Does it work? Success!
</details>

<details>
  <summary>With python</summary>

TODO: Try watchmedo 

https://stackoverflow.com/questions/49355010/how-do-i-watch-python-source-code-files-and-restart-when-i-save

Add a Dockerfile
```
FROM python:latest #docker pull python:3.10.7 last verified

RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && pip install psycopg2
```

build your image

```sh
docker build -t pyapp .
```

add your app to your docker-compose.yml in the services section
```yaml
  app:
    image: pyapp
    container_name: app
    restart: always
    volumes:
      - ./app:/app:Z
    stdin_open: true
    tty: true
    environment:
      PGUSER: app
      PGPASSWORD: 654321
      PGHOST: db
      PGPORT: 5432
      PGDATABASE: project_name
      DATABASE_URL: postgres://${PGUSER}@${PGHOST}:${PGPORT}/${PGDATABASE}
```

Create your python file -- ./data/app/app.py

```python
import psycopg2

conn = None
try:
    # connect to the PostgreSQL server
    print('Connecting to the PostgreSQL database...')
    conn = psycopg2.connect('')

    # create a cursor
    cur = conn.cursor()

# execute a statement
    print('PostgreSQL database version:')
    cur.execute('SELECT * from test;')

    # display the PostgreSQL database server version
    row = cur.fetchone()
    print(row)

# close the communication with the PostgreSQL
    cur.close()
    cur = conn.cursor()
    cur.execute("INSERT INTO test VALUES (default, 'Hi', 'Back') RETURNING *")
    ret = cur.fetchone()
    print (ret)
    conn.commit()
except (Exception, psycopg2.DatabaseError) as error:
    print(error)
finally:
    if conn is not None:
        conn.close()
        print('Database connection closed.')

```

Restart everything
```sh
docker-compose down
docker-compose up -d --build
```

try running your app
```sh
docker exec -it pyapp /bin/bash
python app.py
```
Does it work? Success!
</details>