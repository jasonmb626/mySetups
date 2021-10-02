### Postgres via docker

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

Start the containers (--build makes sure it rebuilds the containers if anything changed)

```sh
docker-compose up --build
```

if you need to access the db container

```sh
docker exec -it docker_db_1 /bin/bash
```

Or if you just need psql

```sh
docker exec -it docker_db_1 /usr/bin/psql -U postgres
```

Create and connect to database

```sql
  CREATE DATABASE project_name;
  \c project_name;
```

Create a role

```sql
  CREATE DATABASE app;
  CREATE ROLE app WITH LOGIN PASSWORD '123456';
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

### Set your environment variables

#### Linux
TODO: how to set for local user only? Not SHELL variables but proper user environment variables
putting these in ~/.pam_environment works in Ubuntu (and ARCH)

```sh
sudo nvim /etc/profile
```

Add to the bottom

```
export PGUSER=app
export PGPASSWORD=123456
export PGHOST=localhost
export PGPORT=5432
export PGDATABASE=project_name
export DATABASE_URL=postgres://${PGUSER}@${PGHOST}:${PGPORT}/${PGDATABASE}
```

Log out and log back in

## Create quick test app

### Node
Create project folder with app.js

```sh
npm init
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