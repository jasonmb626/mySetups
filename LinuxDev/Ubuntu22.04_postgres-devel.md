### Install and run postgres

#### Via Docker
<details>
  <summary>Via Docker</summary>

### Install docker

These instruction copied from [official docker website](https://docs.docker.com/engine/install/ubuntu/)

```sh
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io libpq-devel python3-dev

sudo usermod -aG docker dev
sudo systemctl start docker
sudo systemctl enable docker
```

libpq-devel &  python3-dev only installed because otherwise the python module psycopg2 will fail to install later.

### Install Docker Compose

```sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

From this (link)[https://docs.docker.com/compose/install/]

### Postgres via docker

Create a project directory and put the below in its docker-compose.yml file.

```yaml
version: "3.8"

services:
  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - ../db:/var/lib/postgresql/data
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
```
### Set your environment variables

#### Linux

```sh
vim ~/.pam_environment
```

Add the following

```
PGUSER=app
PGPASSWORD=654321
PGHOST=localhost
PGPORT=5432
PGDATABASE=project_name
DATABASE_URL=postgres://${PGUSER}@${PGHOST}:${PGPORT}/${PGDATABASE}
```

Reboot the system or your user won't have group permission for Docker & environment variables won't yet be loaded.

Start the containers (--build makes sure it rebuilds the containers if anything changed)

```sh
docker-compose up -d --build
```

(Optional) Find out the name of running containers, as this will also be teh server name if connecting from PGAdmin
```sh
docker ps
```
Example output:

CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                            NAMES
49b409b9ed93   postgres         "docker-entrypoint.s…"   21 minutes ago   Up 45 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp        test_docker_db_1
fdf43e55a21b   dpage/pgadmin4   "/entrypoint.sh"         21 minutes ago   Up 45 seconds   443/tcp, 0.0.0.0:8080->80/tcp, :::8080->80/tcp   test_docker_pgadmin_1

In this case, the server name for the postgres server would be test_docker_db_1

if you need to access the db container

```sh
docker exec -it <container name> /bin/bash
```

Or if you just need psql

```sh
docker exec -it <container name> /usr/bin/psql -U postgres
```

</details>

#### Without Docker
<details>
  <summary>Without Docker</summary>

```sh
sudo apt install postgresql postgresql-contrib python3-dev libpq-dev
sudo systemctl start postgresql.service
sudo systemctl enable postgresql.service
```

PGAdmin4 installation failed on Jammy. Isn't officially supported yet.

switch to psql user and run psql
```sh
sudo -i -u postgres
psql
```

Create a role for our dev user

```sql
  CREATE DATABASE dev;
  CREATE ROLE dev WITH SUPERUSER CREATEROLE CREATEDB LOGIN PASSWORD '123456';
  exit
```

Exit back to dev shell

```sh
exit
```

</details>

### Create and connect to database

```sql
  CREATE DATABASE project_name;
  \c project_name;
```

Create a role for our app

```sql
  CREATE DATABASE app;
  CREATE ROLE app WITH LOGIN PASSWORD '654321';
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app;
  GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app;
```

### create a test table

```sql
CREATE TABLE test (
  id SERIAL,
  val1 VARCHAR(20),
  val2 VARCHAR(20)
);
```

### Insert some dummy data for testing

```sql
INSERT INTO test VALUES(default, 'Hi', 'There');
```

## Create quick test app

### Test programmatically

<details>
  <summary>With node</summary>

Create project folder with app.js

```sh
npm init -y
npm i pg
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

Does it work? Success!
</details>

<details>
  <summary>With python</summary>

Create project folder with app.py

set your virtual environment
```sh
python3 -m venv app
source app/bin/activate
pip3 install psycopg2
```

Create your python file

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

Does it work? Success!
</details>