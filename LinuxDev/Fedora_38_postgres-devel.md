### Install and run postgres

### Install Fedora's Docker implementation

```sh
sudo dnf groupinstall 'Development Tools' 'Development Libraries'
sudo dnf install postgresql libpq-devel
```

Do we need the Development tools etc anymore? libpq-devel should not be necessary if using dev container/python interpreter in Docker
groupinstall 'Development Tools' installs things like gcc,'Development Libraries' too, and is my recommendation.

### Start project 

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
  \q
```

From here you should login to psql with new user
```sh
docker exec -it db /usr/bin/psql -U dev -W -d postgres
```


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

Add a Dockerfile for your utility container Dockerfile.npm
```
#docker pull node:18.9.0 latest successful test
FROM node:latest 

RUN userdel -r node

ARG USER_ID

ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user

RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

USER user

WORKDIR /app

ENTRYPOINT [ "npm" ]
```

build your image

```sh
docker build -f ./Dockerfile.npm -t npm --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
```

By making sure container is running as same uid:guid as you, you can init your own project
Make sure you are in your app directory

```sh
mkdir app
cd app
docker run -it --rm -v $(pwd):/app:Z npm npm init
docker run -it --rm -v $(pwd):/app:Z npm npm i pg
```

OR

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

Add a Dockerfile for your app contianer Dockerfile.nodeapp
We'll run this as 1000:1000 (node) but need to make sure we can have root privileges if needed, so add node to sudo and don't require a password
```
#docker pull node:18.9.0 latest successful test
FROM node:latest 

RUN apt-get update && \
      apt-get -y install sudo

RUN echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN adduser node sudo

WORKDIR /app

RUN chown -R 1000:1000 /app

USER node

COPY --chown=1000:1000 ./app/package.json .

RUN npm i

COPY --chown=1000:1000 ./app/* ./

# CMD ["node", "app.js"]
```

add your app to your docker-compose.yml in the services section
```yaml
  app:
    build: ./Dockerfile.nodeapp
    container_name: app
    restart: always
    volumes:
      - ./app:/app:Z
    stdin_open: true
    tty: true
    user: 1000:1000
    environment:
      PGUSER: ${PGUSER}
      PGPASSWORD: 654321
      PGHOST: {PGHOST}
      PGPORT: ${PGPORT}
      PGDATABASE: ${PGDATABASE}
      DATABASE_URL: postgres://${PGUSER}@${PGHOST}:${PGPORT}/${PGDATABASE}
```

This line:
- ./app/node_modules
Ensures that the above volume does not override node_modules folder which is not passed as a volume but is instead actually installed in the image

Tell VSCode about your containers for remote development
create a .devcontainer folder and add your devcontainer.json file
```json
//devcontainer.json
{
  "name": "Node.js",
  "dockerComposeFile": "../docker-compose.yaml",
  "service": "app",
  "runServices": [
    "db",
    "pgadmin"
  ],
  "workspaceFolder": "/app",
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.shell.linux": "/bin/bash"
      },
      "extensions": [
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode"
      ]
    }
  },
  "forwardPorts": [
    3000
  ],
  "remoteUser": "node"
}
```

Create your javascript file
Add an app directory and add your js file (app.js)

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
### Testing

<details>
  <summary>Commandline</summary>

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

</details>

<details>
  <summary>VSCode Remote Environment</summary>

- Open project folder (which contains your dockerfiles etc and has an app subfolder) in VSCode
- With Remove Development Extension installed, bottom left corner click the remote development connection icon, and select "Reopen in Container"
- Open a terminal
```sh
node app.js
```

</details>
Does it work? Success!


</details>

<details>
  <summary>With python</summary>

add a devcontainer.json to .devcontainer folder.
```json
{
  "dockerComposeFile": "../docker-compose.yml",
  "service": "dev",
  "workspaceFolder": "/code/app",
  "remoteUser": "dev",
      "extensions": [
      "ms-python.python",
      "ms-python.vscode-pylance"
    ]
}
```

TODO: Try watchmedo 

https://stackoverflow.com/questions/49355010/how-do-i-watch-python-source-code-files-and-restart-when-i-save

Add a Dockerfile

Resource for permissions:
https://vsupalov.com/docker-shared-permissions/

Dockerfile.dev in root
```
#3.11.4 as of this writing
FROM python:latest 

RUN apt-get update && \
  apt-get -y install sudo

RUN echo 'dev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN adduser dev 

WORKDIR /code

# Copying the requirements, this is needed because at this point the volume isn't mounted yet
COPY requirements.txt /code/

# Installing requirements, if you don't use this, you should.
# More info: https://pip.pypa.io/en/stable/user_guide/
RUN pip install -r requirements.txt

# Similar to the above, but with just the development-specific requirements
COPY requirements-dev.txt /code/
RUN pip install -r requirements-dev.txt

#WORKDIR /app

#RUN chown -R 1000:1000 /app

#COPY --chown=1000:1000 ./app/* ./

USER dev

#CMD ["python", "app.py"]
```

Add your requirements

```sh
echo "psycopg2" >> requirements.txt
touch requirements-dev.txt
```

add your app to your docker-compose.yml in the services section
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
  dev:
    build:
      context: .
      dockerfile: Dockerfile.dev
    container_name: app
    restart: always
    stdin_open: true
    tty: true
    ports:
      - 127.0.0.1:9922:22
    volumes:
      - .:/code:Z
    environment:
      DEV: 'True'
      PGUSER: app
      PGPASSWORD: 654321
      PGHOST: db
      PGPORT: 5432
      PGDATABASE: project_name
      DATABASE_URL: postgres://${PGUSER}@${PGHOST}:${PGPORT}/${PGDATABASE}
volumes:
  appdb:

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