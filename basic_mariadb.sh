#////////////////////////////////////////////////////////////////////////////////
#ps aux|grep mysql

root      6089  22:25   0:00 /bin/bash /usr/bin/mysqld_safe
mysql     6233  22:25   0:00 /usr/sbin/mysqld <...> --socket=/var/run/mysqld/mysqld.sock --port=3306
root      6234  22:25   0:00 logger -t mysqld -p daemon error

#mysqld_safe
mysqld_safe is the recommended way to start a mysqld server on Unix. mysqld_safe adds some safety features such as restarting the server when an error occurs and logging runtime information to an error log. A description of error logging is given later in this section.

#pstree
systemd─┬─accounts-daemon
        ├─mysqld_safe─┬─logger
        │             └─mysqld───23*[{mysqld}]

mysqld clone 23 threads:
    connection manager threads
    signal thread
    read and write threads if InnoDB is used
    event scheduler thread

#mysqld --verbose --help | grep threads
aria-repair-threads                                        1
innodb-file-io-threads                                     4
innodb-purge-threads                                       1
innodb-read-io-threads                                     4
innodb-write-io-threads                                    4
max-delayed-threads                                        20
myisam-repair-threads                                      1
slave-domain-parallel-threads                              0
slave-parallel-threads                                     0
thread-pool-max-threads                                    500


#////////////////////////////////////////////////////////////////////////////////
#mysqld --print-defaults
mysqld would have been started with the following arguments:
--user=mysql
--pid-file=/var/run/mysqld/mysqld.pid
--socket=/var/run/mysqld/mysqld.sock
--port=3306
--basedir=/usr
--datadir=/var/lib/mysql
--tmpdir=/tmp
--lc-messages-dir=/usr/share/mysql
--skip-external-locking
--bind-address=127.0.0.1
--key_buffer_size=16M
--max_allowed_packet=16M
--thread_stack=192K
--thread_cache_size=8
--myisam-recover=BACKUP
--query_cache_limit=1M
--query_cache_size=16M
--log_error=/var/log/mysql/error.log
--expire_logs_days=10
--max_binlog_size=100M
--character-set-server=utf8mb4
--collation-server=utf8mb4_general_ci


Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf ~/.my.cnf

  -b, --basedir=name  Path to installation directory. All paths are usually
                      resolved relative to this
  -h, --datadir=name  Path to the database root directory
  --plugin-dir=name   Directory for plugins
  -u, --user=name     Run mysqld daemon as user.
  --pid-file=name     Pid file used by safe_mysqld
  --socket=name       Socket file to use for connection

#////////////////////////////////////////////////////////////////////////////////
#--datadir: 数据库在硬盘上的存储信息, /var/lib/mysql/下的目录名表示数据库名
root@pek2-office-07-dhcp218:~/sql# ll /var/lib/mysql/
total 110636
drwxr-xr-x  5 mysql mysql     4096 Aug 24 00:56 ./
drwxr-xr-x 55 root  root      4096 Aug 23 22:24 ../
-rw-rw----  1 mysql mysql    16384 Aug 23 22:25 aria_log.00000001
-rw-rw----  1 mysql mysql       52 Aug 23 22:25 aria_log_control
-rw-r--r--  1 root  root         0 Aug 23 22:24 debian-10.0.flag
-rw-rw----  1 mysql mysql 12582912 Aug 24 00:58 ibdata1
-rw-rw----  1 mysql mysql 50331648 Aug 24 00:58 ib_logfile0
-rw-rw----  1 mysql mysql 50331648 Aug 23 22:24 ib_logfile1
-rw-rw----  1 mysql mysql        0 Aug 23 22:25 multi-master.info
-rw-------  1 root  root        15 Aug 23 22:25 mysql_upgrade_info
drwx------  2 mysql root      4096 Aug 23 22:25 mysql/
drwx------  2 mysql mysql     4096 Aug 23 22:25 performance_schema/
drwx------  2 mysql mysql     4096 Aug 24 00:57 test/

#test数据库下面的内容Manufacturers,Products是两张表
└── test
    ├── db.opt
    ├── Manufacturers.frm
    ├── Manufacturers.ibd
    ├── Products.frm
    └── Products.ibd

#ibdata1
ib is abbrev of InnoBase, InnoDB is one of storage engine

MariaDB [(none)]> show variables like 'innodb_data%';
+-----------------------+------------------------+
| Variable_name         | Value                  |
+-----------------------+------------------------+
| innodb_data_file_path | ibdata1:12M:autoextend |
| innodb_data_home_dir  |                        |
+-----------------------+------------------------+

#ib_logfile0/1
redo log https://dev.mysql.com/doc/refman/5.7/en/innodb-redo-log.html


#////////////////////////////////////////////////////////////////////////////////
# check mysql service

systemctl status mysql.service
mysqlreport --user root --password 123456
mysqlcheck -uroot -p123456 --all-databases --fast
