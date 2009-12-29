create table entry (
    entry_id integer primary key auto_increment,
    body text not null,
    title_cache varchar(255) not null,
    html_cache text not null,
    mtime integer,
    revision integer unsigned not null default 1
) engine="innodb";

create table entry_history (
    entry_history_id integer primary key auto_increment,
    entry_id integer not null,
    body text not null,
    ctime integer not null,
    revision integer not null
) engine="innodb";

