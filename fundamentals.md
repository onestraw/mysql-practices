# Database Fundamentals

## ACID

ACID表示原子性（atomicity）、一致性（consistency）、隔离性（isolation）和持久性（durability）


* 原子性（atomicity）
>　一个事务必须被视为一个不可分割的最小工作单元，整个事务中的所有操作要么全部提交成功，要么全部失败回滚


* 一致性（consistency）
>  数据库总是从一个一致性的状态转换到另一个一致性的状态


* 隔离性（isolation）
>  通常来说，一个事务所做的修改在最终提交以前，对其他事务是不可见的


* 持久性（durability）
>　一旦事务提交，则其所做的修改不会永久保存到数据库



### 隔离级别

** 隔离级别越高，并发能力越弱 **

MySQL InnoDB存储引擎默认隔离级别REPEATABLE READ

* READ UNCOMMITTED（未提交读）
>　在READ UNCOMMITTED级别，事务中的修改，即使没有提交，对其他事务也都是可见的。事务可以读取未提交的数据，这也被称为脏读（Dirty Read）


* READ COMMITTED（提交读）
>　大多数数据库系统的默认隔离级别都是READ COMMTTED（但MySQL不是）。READ COMMITTED满足前面提到的隔离性的简单定义：一个事务开始时，只能"看见"已经提交的事务所做的修改。这时会出现一个事务内两次读取数据可能因为其他事务提交的修改导致不一致的情况，称为不可重复读(nonrepeatble read）


* REPEATABLE READ(可重复读)
>　REPEATABLE READ解决了脏读的问题。该隔离级别保证了在同一个事务中多次读取同样记录结果是一致的。但是理论上，可重复读隔离级别还是无法解决另外一个幻读（Phantom Read）的问题。所谓幻读，指的是当某个事务在读取某个范围内的记录时，另一个事务又在该范围内插入了新的记录，当之前的事务再次读取该范围的记录时，会产生幻行（Phantom Row）。InnoDB和XtraDB存储引擎通过多版本并发控制（MVCC，Multiversion Concurrency Control）解决了幻读的问题。


* SERIALIZABLE（可串行化）
>　SERIALIZABLE是最高的隔离级别。它通过强制事务串行执行，避免了前面说的幻读的问题。简单来说，SERIALIZABLE会在读取每一行数据都加锁，所以可能导致大量的超时和锁争用问题。实际应用中也很少用到这个隔离级别，只有在非常需要确保数据的一致性而且可以接受没有并发的情况下，才考虑采用该级别。


## 优秀资料

- [淘宝数据库内核月报](http://mysql.taobao.org/monthly/)
