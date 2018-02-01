# binlog

binary log events

> The binary log contains a record of all changes to the databases, both data and structure, as well as how long each statement took to execute. It consists of a set of binary log files and an index.

> This means that statements such as CREATE, ALTER, INSERT, UPDATE and DELETE will be logged, but statements that have no effect on the data, such as SELECT and SHOW, will not be logged. If you want to log these (at a cost in performance), use the general query log.

binlog 记录所有更改了数据库的操作，可用于实时备份: slave获取master上的binlog，按同样的操作对slave db执行一遍。

## MySQL 主备复制实现原理
![master/slave replication with binlog](resources/mysql_binlog_replication.jpeg)

* master将改变记录到二进制日志(binary log)中（这些记录叫做二进制日志事件，binary log events，可以通过show binlog events进行查看）；
* slave将master的binary log events拷贝到它的中继日志(relay log)；
* slave重做中继日志中的事件，将改变反映它自己的数据。

## Slave/Master交互协议

* 注册：Slave send [COM_REGISTER_SLAVE](https://mariadb.com/kb/en/library/com_register_slave/) packet to Master 
* 请求binlog: Slave send [COM_BINLOG_DUMP](https://mariadb.com/kb/en/library/com_binlog_dump/) or COM_BINLOG_DUMP_GTID packet to Master
    * GTID: Global Transaction Identifier
    * 多长时间同步一次: 在slave发送dump命令之后，master上的dump线程不断的向slave发送binlog更新
    * 怎么记录上次同步的位置：dump命令报头有个4字节的position字段

## 查看binlog
__启用binlog__

取消注释`/etc/mysql/my.cnf`中的`log_bin = /var/log/mysql/mysql-bin.log`


```sql
mysql> show binlog events;
+------------------+-----+-------------+-----------+-------------+---------------------------------------------------------+
| Log_name         | Pos | Event_type  | Server_id | End_log_pos | Info                                                    |
+------------------+-----+-------------+-----------+-------------+---------------------------------------------------------+
| mysql-bin.000001 |   4 | Format_desc |         1 |         107 | Server ver: 5.5.59-0ubuntu0.14.04.1-log, Binlog ver: 4  |
| mysql-bin.000001 | 107 | Query       |         1 |         175 | BEGIN                                                   |
| mysql-bin.000001 | 175 | Query       |         1 |         281 | use `test`; insert into Manufacturers values(123, 'm1') |
| mysql-bin.000001 | 281 | Xid         |         1 |         308 | COMMIT /* xid=121 */                                    |
| mysql-bin.000001 | 308 | Query       |         1 |         376 | BEGIN                                                   |
| mysql-bin.000001 | 376 | Query       |         1 |         481 | use `test`; insert into Manufacturers values(13, 'm2')  |
| mysql-bin.000001 | 481 | Xid         |         1 |         508 | COMMIT /* xid=122 */                                    |
+------------------+-----+-------------+-----------+-------------+---------------------------------------------------------+
7 rows in set (0.00 sec)
```

```bash
bash # mysqlbinlog /var/log/mysql/mysql-bin.000001
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!40019 SET @@session.max_insert_delayed_threads=0*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#180202 15:29:23 server id 1  end_log_pos 107 	Start: binlog v 4, server v 5.5.59-0ubuntu0.14.04.1-log created 180202 15:29:23 at startup
....
```


## 参考

* [阿里 canal](https://github.com/alibaba/canal)
* [Dive into MySQL replication protocol](https://medium.com/@siddontang/dive-into-mysql-replication-protocol-cd14791bcc)
* [处理MySQL协议的GO Lib](https://github.com/siddontang/go-mysql)
* [mysqlbinlog 用法](http://blog.csdn.net/leshami/article/details/41962243)
