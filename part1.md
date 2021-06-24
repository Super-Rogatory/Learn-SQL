# Setting up PostgreSQL

Step 1

    To install the PostgreSQL package onto your system, run the following commands:

$ sudo apt update
$ sudo apt install postgresql postgresql-contrib

Step 2

    To start the PostgreSQL service, run the following command:

$ sudo service postgresql start

Step 3

    Next, we can verify that it is working properly by running the following command:

$ sudo service postgresql status

    You should see something like this:

● postgresql.service - PostgreSQL database server
Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
Active: active (exited) since Wed 2020-11-18 16:59:32 UTC; 1min 59s ago
Process: 1945 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
Main PID: 1945 (code=exited, status=0/SUCCESS)

    Notice how it indicates that it is enabled (meaning it will start on boot) and is active (running). 👌

Step 4

    At this point, we have to create a new user in the PostgreSQL system that matches your currently logged-in username. Users that have access to our database cluster on our computer are referred to as roles in PostgreSQL terms. When installing PostgreSQL, it creates one new user and role called postgres, which is the only role that exists by default. However, we need to allow our logged-in user access to the cluster so we can do our work. For the time being, we will need to create a new role by running our command as the postgres user that the software package installed for us.

    We can run commands on the terminal as another user by using the structure sudo -u [username] [command...]

    So in this case, we want to run the command to create a new role in our database (createuser --superuser $USER) that matches our current logged-in user. To run this command as the postgres user, we would execute it in the following way:

$ sudo -u postgres createuser --superuser $USER

    This may give you an error that it could not change directory to your current directory, that is totally fine.
    Next, we need to create a new database to store information about the new role:

$ createdb

    The previous command creates a new database in the cluster matching the name of our current user.
    Quit out of your terminal and reopen it before moving on to the next step.

Step 5

    Verify that you can run the psql command:

$ psql

psql (12.4)
Type "help" for help.

yourusername=#

    You should see output similar to above. Please type \q to exit the psql shell and continue onto Step 6.

Step 6

    Later, when we use the Node.js Sequelize library, we will attempt to connect to our local PostgreSQL server using Javascript (e.g. const db = new Sequelize('postgres://localhost/database_name')). By default, PostgreSQL will require a username and password for such connections, which means we would have to include that in our JavaScript code as well ('postgres://username:password@localhost/database_name'). To avoid that headache, we've found that it is useful to configure "trust" for such connections.

    PostgreSQL uses a file, pg_hba.conf, to control who can access the databases and what they can do.
        Step 6a: First, we must locate the pg_hba.conf file:

        find / -name pg_hba.conf
        # You might get some warnings about directories that find can't access, ignore them.

        Step 6b: Next, use that file path from the output (should resemble something like /etc/postgresql/12/main/pg_hba.conf) so that we can edit it as root:

        sudo vi /etc/postgresql/12/main/pg_hba.conf

        Step 6c: Then we can edit the file using a text editor called vi.
            Once you're in the file editor, use your arrow keys to navigate to lines that look something like this:

            # TYPE  DATABASE        USER            ADDRESS                 METHOD
            local   all             postgres                                peer
            local   all             all                                     md5
            host    all             all             127.0.0.1/32            md5
            host    all             all             ::1/128                 md5
            #local   replication     postgres                                peer
            #host    replication     postgres        127.0.0.1/32            md5
            #host    replication     postgres        ::1/128                 md5

            For now, change the METHOD for the ones with TYPE equal to local or host to trust. That will mean that your local development machine won't need login/password combinations from your Node programs to access the database. As an example, compare the sample output above to the sample output below.
                To change the file in vi:
                    Type the letter i, which puts you in insert mode.
                    Now you can navigate, use backspace, and type.
                Once you make changes to the relevant lines above:
                    Hit your escape key to leave insert mode.
                    Type a colon (:).
                Type wq and hit the "return/enter" key. This will save the file, and return you to the terminal.

                # TYPE  DATABASE        USER            ADDRESS                 METHOD
                local   all             postgres                                trust
                local   all             all                                     trust
                host    all             all             127.0.0.1/32            trust
                host    all             all             ::1/128                 trust
                #local   replication     postgres                                peer
                #host    replication     postgres        127.0.0.1/32            md5
                #host    replication     postgres        ::1/128                 md5

        Step 6d: Once you're back in the terminal's command line, type the following:

        sudo service postgresql restart

        Step 6e: You should be good to go! Double check by running the following:

        # Go into your PostgreSQL db as the user named postgres:
        psql -U postgres

        # CORRECT SETTINGS:
        psql (9.6.17)
        Type "help" for help.

        postgres=#

        # INCORRECT SETTINGS:
        psql: FATAL:  Peer authentication failed for user "postgres"


## Using VSCode to write SQL.
- We can use VSCode to write SQL.
- '\i' Will allow us to execute scripts that we write in VSCode in our currently connected database.

```
\i somedir/script2.sql
```