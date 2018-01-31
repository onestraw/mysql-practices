## Basic

* 索引 Index
> A data structure that provides a fast lookup capability for rows of a table, typically by forming a tree structure (B-tree) representing all the values of a particular column or set of columns.


* 聚簇索引 Clustered Index
> The InnoDB term for a primary key index. InnoDB table storage is organized based on the values of the primary key columns, to speed up queries and sorts involving the primary key columns.
> Every InnoDB table has a special index called the clustered index where the data for the rows is stored. Typically, the clustered index is synonymous with the primary key. Accessing a row through the clustered index is fast because the index search leads directly to the page with all the row data.


* 二级(辅助)索引 Secondary Index
> A type of InnoDB index that represents a subset of table columns. A secondary index can be used to satisfy queries that only require values from the indexed columns. 
非聚簇索引即是二级索引


* 单列索引 Column Index
> An index on a single column.


* 联合索引 Composite Index
> An index that includes multiple columns.


* 单列前缀索引 Partial Index
> An index that represents only part of a column value, typically the first N characters (the prefix) of a long VARCHAR value.
在其他类型的数据库中指的是 filtered index, 如[PostgreSQL Partial Index](https://huoding.com/2016/04/28/510)
> A partial index, also known as filtered index is an index which has some condition applied to it so that it includes a subset of rows in the table.

```sql
create index partial_status on txn_table (status)
where status in ('A', 'P', 'W');
```


* 最左前缀匹配 leftmost prefix
> For example, if you have a three-column index on (col1, col2, col3), you have indexed search capabilities on (col1), (col1, col2), and (col1, col2, col3).  MySQL cannot use the index to perform lookups if the columns do not form a leftmost prefix of the index. Suppose that you have the SELECT statements shown here:

```sql
SELECT * FROM tbl_name WHERE col1=val1;
SELECT * FROM tbl_name WHERE col1=val1 AND col2=val2;

SELECT * FROM tbl_name WHERE col2=val2;
SELECT * FROM tbl_name WHERE col2=val2 AND col3=val3;
```

前两条select可以使用 (col1, col2, col3) 上的索引，后两条不行，因为违反了最左前缀匹配原则


## [索引相关常用命令](http://blog.csdn.net/bigtree_3721/article/details/51335479)

1) 创建主键
```sql
 CREATE TABLE `pk_tab2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `a1` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```


2) 创建唯一索引
```sql
create unique index indexname on tablename(columnname);
alter table tablename add unique index indexname(columnname);
```


3) 创建单列一般索引
```sql
create index indexname on tablename(columnname);
alter table tablename add index indexname(columnname);
```


4) 创建单列前缀索引
```sql
create index indexname on tablename(columnname(10));    //单列的前10个字符创建前缀索引
alter table tablename add index indexname(columnname(10)); //单列的前10个字符创建前缀索引
```


5) 创建复合索引
```sql
create index indexname on tablename(columnname1，columnname2);    //多列的复合索引
create index indexname on tablename(columnname1，columnname2(10));    //多列的包含前缀的复合索引
alter table tablename add index indexname(columnname1，columnname2); //多列的复合索引
alter table tablename add index indexname(columnname1，columnname(10)); //多列的包含前缀的复合索引
```


6) 删除索引
```sql
drop index indexname on tablename;;
alter table tablename drop  index indexname;
```


7) 查看索引
```sql
show index from tablename;
show create table pk_tab2;
```


## Reference

- [MySQL索引原理及慢查询优化](https://tech.meituan.com/mysql-index.html)
- [MySQL索引背后的数据结构及算法原理](http://blog.codinglabs.org/articles/theory-of-mysql-index.html)
- [MySQL Explain实例](http://www.cnitblog.com/aliyiyi08/archive/2008/09/09/48878.html)
- [MySQL 5.7 Reference Manual](https://dev.mysql.com/doc/refman/5.7/en/)
- search `site:mysql.taobao.org 索引`
