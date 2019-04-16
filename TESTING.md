# Testing

## Unit tests
This project has a suite of unit tests that cover a good deal of its functionality.

The unit test suite may be run by following the instructions in [Setting up the development environment](CONTRIBUTE.md#Setting up the development environment).

## Manual tests

Due to the nature of some functionality encoded in these tools, some functionality is not amenable to being tested in unit tests. In those cases, manual testing must be performed.

### pt-online-schema-change

#### Database reconnect feature

The database reconnect logic in pt-online-schema-change is not amenable to unit testing because the test procedure requires that the database connection be dropped immediately prior to one of the critical operations referenced in the `--tries` documentation.

##### Preparation

Create the test database and table:

```bash
$ mysql -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.15 Homebrew

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database foo;
Query OK, 1 row affected (0.00 sec)

mysql> create table widgets ( id INT AUTO_INCREMENT, PRIMARY KEY (id) ) ENGINE=INNODB;
Query OK, 0 rows affected (0.00 sec)
```

Then run the tests as described in the next sections.

##### Trial 1 - Upon database disconnect, try to reconnect repeatedly until all retry attempts are exhausted

Perform the test:

```bash
# <<<<<<<<<<<<<<< THIS IS WHERE I STARTED MYSQL >>>>>>>>>>>>>>>
dellis:~/projects/percona-toolkit (ptosc_reconnect) $ bin/pt-online-schema-change --user=root --reconnect 5 --execute --alter "ENGINE=InnoDB" D=foo,t=widgets
Reconnect retry count = 5No slaves found.  See --recursion-method if host pd-davidellis.lan has slaves.
Not checking slave lag because no slaves were found and --check-slave-lag was not specified.
Operation, tries, wait:
  analyze_table, 10, 1
  copy_rows, 10, 0.25
  create_triggers, 10, 1
  drop_triggers, 10, 1
  swap_tables, 10, 1
  update_foreign_keys, 10, 1
Altering `foo`.`widgets`...
Creating new table...
Created new table foo._widgets_new OK.
Altering new table...
Altered `foo`.`_widgets_new` OK.
2019-04-12T15:28:58 Creating triggers...
2019-04-12T15:28:58 Created triggers OK.
2019-04-12T15:28:58 Copying approximately 1 rows...
2019-04-12T15:28:58 Copied rows OK.
2019-04-12T15:28:58 Analyzing new table...
2019-04-12T15:28:58 Swapping tables...
2019-04-12T15:28:58 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
# <<<<<<<<<<<<<<< THIS IS WHERE I SHUTDOWN MYSQL >>>>>>>>>>>>>>>
2019-04-12T15:29:18 Failed to reconnect. Attempting to reconnect. Try #1
2019-04-12T15:29:19 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
2019-04-12T15:29:39 Failed to reconnect. Attempting to reconnect. Try #2
2019-04-12T15:29:40 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
2019-04-12T15:30:00 Failed to reconnect. Attempting to reconnect. Try #3
2019-04-12T15:30:01 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
2019-04-12T15:30:21 Failed to reconnect. Attempting to reconnect. Try #4
2019-04-12T15:30:22 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
2019-04-12T15:30:42 Failed to reconnect. Attempting to reconnect. Try #5
2019-04-12T15:30:43 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
2019-04-12T15:31:03 Dropping triggers...
2019-04-12T15:31:03 Failed to reconnect. Attempting to reconnect. Try #1
2019-04-12T15:31:04 Failed to reconnect. Attempting to reconnect. Try #2
2019-04-12T15:31:05 Failed to reconnect. Attempting to reconnect. Try #3
2019-04-12T15:31:06 Failed to reconnect. Attempting to reconnect. Try #4
2019-04-12T15:31:07 Failed to reconnect. Attempting to reconnect. Try #5
2019-04-12T15:31:08 Error dropping trigger: Cannot connect to MySQL: DBI connect('foo;;mysql_read_default_group=client','root',...) failed: Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2) at bin/pt-online-schema-change line 2345.




2019-04-12T15:31:08 Failed to reconnect. Attempting to reconnect. Try #1
2019-04-12T15:31:09 Failed to reconnect. Attempting to reconnect. Try #2
2019-04-12T15:31:10 Failed to reconnect. Attempting to reconnect. Try #3
2019-04-12T15:31:11 Failed to reconnect. Attempting to reconnect. Try #4
2019-04-12T15:31:12 Failed to reconnect. Attempting to reconnect. Try #5
2019-04-12T15:31:13 Error dropping trigger: Cannot connect to MySQL: DBI connect('foo;;mysql_read_default_group=client','root',...) failed: Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2) at bin/pt-online-schema-change line 2345.




2019-04-12T15:31:13 Failed to reconnect. Attempting to reconnect. Try #1
2019-04-12T15:31:14 Failed to reconnect. Attempting to reconnect. Try #2
2019-04-12T15:31:15 Failed to reconnect. Attempting to reconnect. Try #3
2019-04-12T15:31:16 Failed to reconnect. Attempting to reconnect. Try #4
2019-04-12T15:31:17 Failed to reconnect. Attempting to reconnect. Try #5
2019-04-12T15:31:18 Error dropping trigger: Cannot connect to MySQL: DBI connect('foo;;mysql_read_default_group=client','root',...) failed: Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2) at bin/pt-online-schema-change line 2345.




2019-04-12T15:31:18 To try dropping the triggers again, execute:
DROP TRIGGER IF EXISTS `foo`.`pt_osc_foo_widgets_del`
DROP TRIGGER IF EXISTS `foo`.`pt_osc_foo_widgets_upd`
DROP TRIGGER IF EXISTS `foo`.`pt_osc_foo_widgets_ins`
`foo`.`widgets` was not altered.
2019-04-12T15:31:03 Error swapping tables: 2019-04-12T15:31:03 Cannot connect to MySQL: DBI connect('foo;;mysql_read_default_group=client','root',...) failed: Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2) at bin/pt-online-schema-change line 2345.
```

Clean up and prepare for next trial run:

```bash
$ mysql -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.15 Homebrew

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> drop table _widgets_new;
Query OK, 0 rows affected (0.02 sec)

mysql> drop table widgets;
Query OK, 0 rows affected (0.00 sec)

mysql> create table widgets ( id INT AUTO_INCREMENT, PRIMARY KEY (id) ) ENGINE=INNODB;
Query OK, 0 rows affected (0.00 sec)
```


##### Trial 2 - Upon database disconnect, try to reconnect repeatedly until database connection is re-established within the maximum number of retry attempts

```bash
#<<<<<<<<<<<<<<< THIS IS WHERE I STARTED MYSQL >>>>>>>>>>>>>>>
dellis:~/projects/percona-toolkit (ptosc_reconnect) $ bin/pt-online-schema-change --user=root --reconnect 5 --execute --alter "ENGINE=InnoDB" D=foo,t=widgets
Reconnect retry count = 5No slaves found.  See --recursion-method if host pd-davidellis.lan has slaves.
Not checking slave lag because no slaves were found and --check-slave-lag was not specified.
Operation, tries, wait:
  analyze_table, 10, 1
  copy_rows, 10, 0.25
  create_triggers, 10, 1
  drop_triggers, 10, 1
  swap_tables, 10, 1
  update_foreign_keys, 10, 1
Altering `foo`.`widgets`...
Creating new table...
Created new table foo._widgets_new OK.
Altering new table...
Altered `foo`.`_widgets_new` OK.
2019-04-12T15:32:08 Creating triggers...
2019-04-12T15:32:08 Created triggers OK.
2019-04-12T15:32:08 Copying approximately 1 rows...
2019-04-12T15:32:08 Copied rows OK.
2019-04-12T15:32:08 Analyzing new table...
2019-04-12T15:32:08 Swapping tables...
2019-04-12T15:32:08 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
#<<<<<<<<<<<<<<< THIS IS WHERE I SHUTDOWN MYSQL >>>>>>>>>>>>>>>
2019-04-12T15:32:28 Failed to reconnect. Attempting to reconnect. Try #1
2019-04-12T15:32:29 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
2019-04-12T15:32:49 Failed to reconnect. Attempting to reconnect. Try #2
2019-04-12T15:32:50 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
#<<<<<<<<<<<<<<< THIS IS WHERE I STARTED MYSQL >>>>>>>>>>>>>>>
2019-04-12T15:33:11 Sleeping 20 seconds before running SQL: RENAME TABLE `foo`.`widgets` TO `foo`.`_widgets_old`, `foo`.`_widgets_new` TO `foo`.`widgets`
2019-04-12T15:33:31 Swapped original and new tables OK.
2019-04-12T15:33:31 Dropping old table...
2019-04-12T15:33:31 Dropped old table `foo`.`_widgets_old` OK.
2019-04-12T15:33:31 Dropping triggers...
2019-04-12T15:33:31 Dropped triggers OK.
Successfully altered `foo`.`widgets`.
```

Clean up and prepare for next trial run:

```bash
$ mysql -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.15 Homebrew

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> drop table widgets;
Query OK, 0 rows affected (0.00 sec)

mysql> create table widgets ( id INT AUTO_INCREMENT, PRIMARY KEY (id) ) ENGINE=INNODB;
Query OK, 0 rows affected (0.00 sec)
```
