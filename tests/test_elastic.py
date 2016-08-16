from pytest_dbfixtures import factories


def test_elastic_process(elasticsearch_proc):
    """Simple test for starting elasticsearch_proc."""
    assert elasticsearch_proc.running() is True


def test_elasticsarch(elasticsearch):
    """Tests if elasticsearch fixtures connects to process."""
    assert elasticsearch.cluster.health()['status'] == 'green'


elasticsearch_proc_random = factories.elasticsearch_proc(port=None)
elasticsearch_random = factories.elasticsearch('elasticsearch_proc_random')


def test_random_port(elasticsearch_random):
    """Tests if elasticsearch fixture can be started on random port"""
    assert elasticsearch_random.cluster.health()['status'] == 'green'


def test_index_creation(elasticsearch):
    """Tests if index creation via elasticsearch fixture succeeds"""
    name = 'mytestindex'
    elasticsearch.indices.create(index=name)
    assert name in elasticsearch.indices.get_settings().keys()
