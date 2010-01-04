{
    'DB' => {
        'dsn' => 'dbi:mysql:database=dev_Inamode13',
        username => 'root',
        password => '',
        connect_options => +{
            'mysql_enable_utf8' => 1,
            'mysql_read_default_file' => '/etc/mysql/my.cnf',
        },
    },
    'V::MT' => {
        cache_mode => 2,
    },
};
