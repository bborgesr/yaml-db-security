## Minimal security for database credentials in deployed Shiny apps

### Steps:
1. Have a `_appname_-db.yml` file (specifying the credentials needed for the app named `_appname_` to access the database)
2. Read that file inside the app using `yaml.load_file("path/to/file/_appname_-db.yml")` in `app.R`, `server.R` or `global.R`
3. Try to create a pool using those credentials

### Implementations
#### Shiny Server
This is a better approach than simply hardcoding the credentials in. However, the `_appname_-db.yml` 
file still needs to be stored in your server. So while not everyone sees your credentials 
(unlike the situation when you hardcode them), some people still do. In particular, these
are other app authors using the same server and the same `run_as` user (typically, this is 
`shiny`).

As the sys admin, you will need to create a special folder outside the Shiny Server webroot, 
change the owner to `shiny` and give it 700 permissions. For example:

```bash
# As root, create folder
sudo mkdir /etc/shiny-server/credentials/

# Change the folder to be owned by the shiny user
sudo chown shiny:shiny /etc/shiny-server/credentials

# Set the permissions
sudo chmod 700 /etc/shiny-server/credentials
```

Then, for each app, create (or copy) the appropriate YAML file into that directory, change the 
owner to `shiny` and give it 600 permissions. For example:

```bash
# As root, copy appropriate file
sudo cp path/to/file/_appname_-db.yml /etc/shiny-server/credentials/

# Change the file to be owned by the shiny user
sudo chown shiny:shiny /etc/shiny-server/credentials/_appname_-db.yml

# Set the permissions
sudo chmod 600 /etc/shiny-server/credentials/_appname_-db.yml
```

Then instruct the app authors to read the corresponding file from that location:

```r
credentials <- yaml::yaml.load_file("/etc/shiny-server/credentials/_appname_-db.yml")
```

#### Connect and shinyapps.io
As of this moment, the best you can do in Connect and shinyapps.io is to put the 
yml file in the app directory but gitignore it. So, everyone who has access to the 
your Connect/shinyapps.io account will be able to see these.

### Future
We hope to continue working on better security for credentials. In particular, this 
does not yet address how to safely pass in credentials at runtime (i.e. provided by 
the app's user). So even though you can use seemingly safe login forms (with modal 
windows and [passwordInputs](http://shiny.rstudio.com/reference/shiny/latest/passwordInput.html)),
these actually do not offer any protection under the covers. I.e. unless you 
restrict access to the whole app, once a user has access to it, there's is no 
additonal, built-in security mechanism.
