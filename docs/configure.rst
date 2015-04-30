.. _configure:

Use your own configure files
============================

Below you can see example configs.

* pytest_dbfixtures/dbfixtures.conf
* pytest_dbfixtures/redis.conf
* pytest_dbfixtures/rabbit.conf

If you want to use your own configs pass them as arguments to ``py.test`` command.

.. sourcecode:: bash

    $ py.test --dbfixtures-config my-dbfixtures.conf

    $ py.test --dbfixtures-config my-dbfixtures.conf --redis-config my-redis.conf

    $ py.test --redis-config my-redis.conf

    $ py.test --rabbit-config my-rabbit.conf


Use your custom path for logs
=============================

You can collect logs from all databases in a custom path by passing ``--dbfixtures-logsdir`` argument to ``py.test`` command.

.. sourcecode:: bash

    $ py.test --dbfixtures-logsdir /my/custom/path


Custom prefix for log file of log directory
-------------------------------------------

Additionaly you can add prefix to log file or log directory for each database fixture. Just pass the ``logs_prefix`` argument.

Example:

.. sourcecode:: python

    mysql_proc = factories.mysql_proc(port=3308, logs_prefix='myproject-')


How the executable files are searched  
=====================================

Configuration file contain information where to find the executables of each supported database and storage engine.
Executables may be indicated with (or without) an absolute path, for instance:

.. sourcecode:: python

    example_exec: /usr/local/bin/example

or

.. sourcecode:: python

    example_exec: example

File search rules are as follows:

1) The factories arguments have the highest priority (if you are not using factories directly, or you are not using arguments 
   to determine the executables, then see point 2) 
2) In second step the process try to use value from configuration file literally (it has sense for an absolute path) 
3) At least, if the previous check fails (file or path does not exists), the process determines the "base name" of the executable 
   (for instance for '/_not_existent_path/example', the "base name" is 'example') and tries to find it using every path from PATH 
   environment variable (till first success).

   