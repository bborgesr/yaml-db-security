## Minimal security for database credentials

### Steps:
1. Have a `db.yml` file (specifying the credentials) one directory above your app.
2. Read that file using `yaml.load_file("../db.yml")` in `app.R`, `server.R` or `global.R`
3. Try to create a pool using those credentials

### Caveats
#### Shiny Server
This is a better approach than simply hardcoding the credentials in. However, the `db.yml` 
file still needs to be stored in your server. So while not everyone sees your credentials 
(unlike the situation when you hardcode them), some people still do. In particular, these
are other app authors using the same server and the same `run_as` user (typically, this is 
`shiny`).

#### Connect
???
