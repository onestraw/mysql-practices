#////////////////////////////////////////////////////////////////////////////////
# mysql use unix_socket plugin for root@localhost, so root@localhost could connect server with unix socket without verification
# enable login verification for root@localhost
MariaDB [mysql]> select host,user,password,plugin from mysql.user;
+--------------+-----------+-------------------------------------------+-------------+
| host         | user      | password                                  | plugin      |
+--------------+-----------+-------------------------------------------+-------------+
| localhost    | root      | *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9 | unix_socket |
+--------------+-----------+-------------------------------------------+-------------+
MariaDB [mysql]> UPDATE user SET plugin='mysql_native_password' WHERE User='root';

MariaDB [mysql]> select host,user,password,plugin from mysql.user;
+--------------+-----------+-------------------------------------------+-----------------------+
| host         | user      | password                                  | plugin                |
+--------------+-----------+-------------------------------------------+-----------------------+
| localhost    | root      | *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9 | mysql_native_password |
+--------------+-----------+-------------------------------------------+-----------------------+

service mysql restart

- set password if there is no password for root
    `mysql` will login with root without verification
    mysql > set password=PASSWORD('123456');

#////////////////////////////////////////////////////////////////////////////////
# secure your database
# refer http://www.hexatier.com/mysql-database-security-best-practices/
- modify bind-address to 'public-ip' in /etc/mysql/mariadb.conf.d/50-server.cnf
- restrict remote access
    mysql> GRANT SELECT, INSERT ON mydb.* TO 'someuser'@'somehost' identified by 'password';

    mysql -h <mysql-server-public-ip> -u root -p

Example:
    grant all on test.* to 'root'@'10.117.4.189' identified by 'qaz123';
    revoke all on test.* from 'root'@'10.117.4.189';

    create user rootadmin;
    rename user 'root'@'10.117.4.189' to 'rootadmin'@'10.117.4.189';


#////////////////////////////////////////////////////////////////////////////////
# backup & restore
mysqldump [-u root -p ] testdb > testdb.sql
mysqladmin [-u root -p ] create newdb
mysql [-u root -p] newdb < testdb.sql
#mysqlimport is used to load single table data
mysqladmin [-u root -p ] drop testdb
mysqlshow


#////////////////////////////////////////////////////////////////////////////////
# enable log [just study as it's performance killer]
edit /etc/mysql/mariadb.conf.d/50-server.cnf

general_log_file        = /var/log/mysql/mysql.log
general_log             = 1

this log record sql statsments from server side
~/.mysql_history record sql statsments from client side


#////////////////////////////////////////////////////////////////////////////////
# take from https://gist.github.com/hofmannsven/9164408
===============

Getting started: 
- http://www.sqlteaching.com/
- https://www.codecademy.com/courses/learn-sql

Related tutorials:
- [MySQL-CLI](https://www.youtube.com/playlist?list=PLfdtiltiRHWEw4-kRrh1ZZy_3OcQxTn7P)
- [Analyzing Business Metrics](https://www.codecademy.com/learn/sql-analyzing-business-metrics)
- [SQL joins infografic](https://lh4.googleusercontent.com/-RdjzcoAwBYg/UxTXWGJHgoI/AAAAAAAACrs/Gqbu6zyksgo/w852-h670/sql-joins.jpg)

Tools:
- [DataGrip](https://www.jetbrains.com/datagrip/)
- [Sequel Pro](http://www.sequelpro.com/)


Commands
-----------

Access monitor: `mysql -u [username] -p;` (will prompt for password)

Show all databases: `show databases;`

Access database: `mysql -u [username] -p [database]` (will prompt for password)

Create new database: `create database [database];`

Select database: `use [database];`

Determine what database is in use: `select database();`

Show all tables: `show tables;`

Show table structure: `describe [table];`

List all indexes on a table: `show index from [table];`

Create new table with columns: `CREATE TABLE [table] ([column] VARCHAR(120), [another-column] DATETIME);`

Adding a column: `ALTER TABLE [table] ADD COLUMN [column] VARCHAR(120);`

Adding a column with an unique, auto-incrementing ID: `ALTER TABLE [table] ADD COLUMN [column] int NOT NULL AUTO_INCREMENT PRIMARY KEY;`

Inserting a record: `INSERT INTO [table] ([column], [column]) VALUES ('[value]', [value]');`

MySQL function for datetime input: `NOW()`

Selecting records: `SELECT * FROM [table];`

Explain records: `EXPLAIN SELECT * FROM [table];`

Selecting parts of records: `SELECT [column], [another-column] FROM [table];`

Counting records: `SELECT COUNT([column]) FROM [table];`

Counting and selecting grouped records: `SELECT *, (SELECT COUNT([column]) FROM [table]) AS count FROM [table] GROUP BY [column];`

Selecting specific records: `SELECT * FROM [table] WHERE [column] = [value];` (Selectors: `<`, `>`, `!=`; combine multiple selectors with `AND`, `OR`)

Select records containing `[value]`: `SELECT * FROM [table] WHERE [column] LIKE '%[value]%';`

Select records starting with `[value]`: `SELECT * FROM [table] WHERE [column] LIKE '[value]%';`

Select records starting with `val` and ending with `ue`: `SELECT * FROM [table] WHERE [column] LIKE '[val_ue]';`

Select a range: `SELECT * FROM [table] WHERE [column] BETWEEN [value1] and [value2];`

Select with custom order and only limit: `SELECT * FROM [table] WHERE [column] ORDER BY [column] ASC LIMIT [value];` (Order: `DESC`, `ASC`)

Updating records: `UPDATE [table] SET [column] = '[updated-value]' WHERE [column] = [value];`

Deleting records: `DELETE FROM [table] WHERE [column] = [value];`

Delete *all records* from a table (without dropping the table itself): `DELETE FROM [table];`
(This also resets the incrementing counter for auto generated columns like an id column.)

Delete all records in a table: `truncate table [table];`

Removing table columns: `ALTER TABLE [table] DROP COLUMN [column];`

Deleting tables: `DROP TABLE [table];`

Deleting databases: `DROP DATABASE [database];`

Custom column output names: `SELECT [column] AS [custom-column] FROM [table];`

Export a database dump (more info [here](http://stackoverflow.com/a/21091197/1815847)): `mysqldump -u [username] -p [database] > db_backup.sql`

Use `--lock-tables=false` option for locked tables (more info [here](http://stackoverflow.com/a/104628/1815847)).

Import a database dump (more info [here](http://stackoverflow.com/a/21091197/1815847)): `mysql -u [username] -p -h localhost [database] < db_backup.sql`

Logout: `exit;`


Aggregate functions
-----------

Select but without duplicates: `SELECT distinct name, email, acception FROM owners WHERE acception = 1 AND date >= 2015-01-01 00:00:00`

Calculate total number of records: `SELECT SUM([column]) FROM [table];`

Count total number of `[column]` and group by `[category-column]`: `SELECT [category-column], SUM([column]) FROM [table] GROUP BY [category-column];`

Get largest value in `[column]`: `SELECT MAX([column]) FROM [table];`

Get smallest value: `SELECT MIN([column]) FROM [table];`

Get average value: `SELECT AVG([column]) FROM [table];`

Get rounded average value and group by `[category-column]`: `SELECT [category-column], ROUND(AVG([column]), 2) FROM [table] GROUP BY [category-column];`


Multiple tables
-----------

Select from multiple tables: `SELECT [table1].[column], [table1].[another-column], [table2].[column] FROM [table1], [table2];`

Combine rows from different tables: `SELECT * FROM [table1] INNER JOIN [table2] ON [table1].[column] = [table2].[column];`

Combine rows from different tables but do not require the join condition: `SELECT * FROM [table1] LEFT OUTER JOIN [table2] ON [table1].[column] = [table2].[column];` (The left table is the first table that appears in the statement.)

Rename column or table using an _alias_: `SELECT [table1].[column] AS '[value]', [table2].[column] AS '[value]' FROM [table1], [table2];`


Users functions
-----------

List all users: `SELECT User,Host FROM mysql.user;`

Create new user: `CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';`

Grant `ALL` access to user for `*` tables: `GRANT ALL ON database.* TO 'user'@'localhost';`
