import platform

import pytest

from pytest_dbfixtures import factories


query = '''CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20),
    species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);'''

# mysqlclient requires a Python 3 C API function PyUnicode_AsUTF8 which is not available yet in PyPy3.
pypy3 = (platform.python_implementation() == 'PyPy' and platform.python_version_tuple()[0] == '3')


def test_proc(mysql_proc):
    assert mysql_proc.running()


@pytest.mark.skipif(pypy3, reason='mysqlclient doesn\'t support PyPy3')
def test_mysql(mysql):
    cursor = mysql.cursor()
    cursor.execute(query)
    mysql.commit()
    cursor.close()


mysql_proc2 = factories.mysql_proc(port=3308, params='--skip-sync-frm')
mysql2 = factories.mysql('mysql_proc2')


@pytest.mark.skipif(pypy3, reason='mysqlclient doesn\'t support PyPy3')
def test_mysql_newfixture(mysql, mysql2):
    cursor = mysql.cursor()
    cursor.execute(query)
    mysql.commit()
    cursor.close()

    cursor = mysql2.cursor()
    cursor.execute(query)
    mysql2.commit()
    cursor.close()


mysql_rand_proc = factories.mysql_proc(port=None, params='--skip-sync-frm')
mysql_rand = factories.mysql('mysql_proc2')


@pytest.mark.skipif(pypy3, reason='mysqlclient doesn\'t support PyPy3')
def test_random_port(mysql_rand):
    """Tests if mysql fixture can be started on random port"""
    mysql = mysql_rand
    mysql.cursor()
