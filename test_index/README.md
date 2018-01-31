# Induction

## basic

Indexes are used to find rows with specific column values quickly. Without an index, MySQL must begin with the first row and then read through the entire table to find the relevant rows. The larger the table, the more this costs. If the table has an index for the columns in question, MySQL can quickly determine the position to seek to in the middle of the data file without having to look at all the data. This is much faster than reading every row sequentially.

Most MySQL indexes (PRIMARY KEY, UNIQUE, INDEX, and FULLTEXT) are stored in B-trees. Exceptions: Indexes on spatial data types use R-trees; MEMORY tables also support hash indexes; InnoDB uses inverted lists for FULLTEXT indexes.

click [here](https://dev.mysql.com/doc/refman/5.7/en/mysql-indexes.html) for details.

# Commands
```
create index name_index on Products (name);
show index from Products;
drop index name_index on Products;
```

# Example

- run `./boot.sh` to prepare the database
- get into the db shell to exec following steps

```
MariaDB> select * from Products where name=(select name from Products where code=123321);
MariaDB> create index name_index on Products (name);
MariaDB> select * from Products where name=(select name from Products where code=234432);
```


```
MariaDB [test_index]> select count(*) as total from Products;
+--------+
| total  |
+--------+
| 300010 |
+--------+
1 row in set (0.00 sec)

MariaDB [test_index]> select * from Products where name=(select name from Products where code=123321);
+--------+------------+-------+--------------+
| Code   | Name       | Price | Manufacturer |
+--------+------------+-------+--------------+
| 123321 | QJyQjfMmRY | 23911 |            4 |
+--------+------------+-------+--------------+
1 row in set (0.12 sec)

MariaDB [test_index]> create index name_index on Products (name);
Query OK, 0 rows affected, 1 warning (0.88 sec)     
Records: 0  Duplicates: 0  Warnings: 1

MariaDB [test_index]> show index from Products;
+----------+------------+--------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table    | Non_unique | Key_name     | Seq_in_index | Column_name  | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+----------+------------+--------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Products |          0 | PRIMARY      |            1 | Code         | A         |      299523 |     NULL | NULL   |      | BTREE      |         |               |
| Products |          1 | Manufacturer |            1 | Manufacturer | A         |          10 |     NULL | NULL   |      | BTREE      |         |               |
| Products |          1 | name_index   |            1 | Name         | A         |      299523 |      191 | NULL   |      | BTREE      |         |               |
+----------+------------+--------------+--------------+--------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
3 rows in set (0.00 sec)

MariaDB [test_index]> select * from Products where name=(select name from Products where code=234432);
+--------+------------+-------+--------------+
| Code   | Name       | Price | Manufacturer |
+--------+------------+-------+--------------+
| 234432 | hvOKGblLdj | 70043 |            6 |
+--------+------------+-------+--------------+
1 row in set (0.00 sec)
```
