create table entry (
    entry_id integer primary key auto_increment,
    body text not null,
    title_cache varchar(255) not null,
    html_cache text not null,
    mtime timestamp
) engine="innodb";

create table entry_history (
    entry_id integer primary key auto_increment,
    body text not null,
    ctime integer unsigned
) engine="innodb";

