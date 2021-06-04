# nicegres

nicegres will let you create postgres Docker containers with initial databases and users created.
This will allow you using the same container for many applications with different databases to not use the superuser created by default.

## How does it work?

Simply define the `POSTGRES_SETUPS` environment variable like this: `user:pass,user2:pass2`.
This will create the users **and** databases `user` and `user2` with their given passwords, every user being granted all permissions to his corresponding database.

You may also skip defining the password part to use the remaining value for the username, password and database name.

If you want a database to be created with another name than the corresponding user has, you can specify a third value: `user:pass:db`.
This will use `db` as the database name assigned to the user `user` with the password `pass`.

As you may have noticed above, multiple setups can be used by separating them with a comma (`,`).

### Example

```shell
docker run -d \
    -p 5432:5432 \
    --name nicegres \
    -e POSTGRES_PASSWORD="superuser_password" \
    -e POSTGRES_SETUPS="user1:pass1:db1,user2:pass2,user3" \
    ghcr.io/lus/nicegres:latest
```

**NOTE:** This feature will **not** let you bypass the requirement of a `POSTGRES_PASSWORD` variable used for the superuser!

## The built image is old / Postgres got an update. What should I do?

nicegres will be rebuilt every 24h. If it is mandatory to update it beforehand, build the image yourself or tell me to manually trigger it.