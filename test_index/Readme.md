# Induction

## basic

Indexes are used to find rows with specific column values quickly. Without an index, MySQL must begin with the first row and then read through the entire table to find the relevant rows. The larger the table, the more this costs. If the table has an index for the columns in question, MySQL can quickly determine the position to seek to in the middle of the data file without having to look at all the data. This is much faster than reading every row sequentially.

Most MySQL indexes (PRIMARY KEY, UNIQUE, INDEX, and FULLTEXT) are stored in B-trees. Exceptions: Indexes on spatial data types use R-trees; MEMORY tables also support hash indexes; InnoDB uses inverted lists for FULLTEXT indexes.

click [here](https://dev.mysql.com/doc/refman/5.7/en/mysql-indexes.html) for details.

## Clustered and Secondary Indexes

Every InnoDB table has a special index called the clustered index where the data for the rows is stored. Typically, the clustered index is synonymous with the primary key. To get the best performance from queries, inserts, and other database operations, you must understand how InnoDB uses the clustered index to optimize the most common lookup and DML operations for each table.

When you define a PRIMARY KEY on your table, InnoDB uses it as the clustered index. Define a primary key for each table that you create. If there is no logical unique and non-null column or set of columns, add a new auto-increment column, whose values are filled in automatically.

If you do not define a PRIMARY KEY for your table, MySQL locates the first UNIQUE index where all the key columns are NOT NULL and InnoDB uses it as the clustered index.

If the table has no PRIMARY KEY or suitable UNIQUE index, InnoDB internally generates a hidden clustered index on a synthetic column containing row ID values. The rows are ordered by the ID that InnoDB assigns to the rows in such a table. The row ID is a 6-byte field that increases monotonically as new rows are inserted. Thus, the rows ordered by the row ID are physically in insertion order.

How the Clustered Index Speeds Up Queries

Accessing a row through the clustered index is fast because the index search leads directly to the page with all the row data. If a table is large, the clustered index architecture often saves a disk I/O operation when compared to storage organizations that store row data using a different page from the index record.

How Secondary Indexes Relate to the Clustered Index

All indexes other than the clustered index are known as secondary indexes. In InnoDB, each record in a secondary index contains the primary key columns for the row, as well as the columns specified for the secondary index. InnoDB uses this primary key value to search for the row in the clustered index.

If the primary key is long, the secondary indexes use more space, so it is advantageous to have a short primary key.

[reference](https://dev.mysql.com/doc/refman/5.7/en/innodb-index-types.html)


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
