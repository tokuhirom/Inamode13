create table entry (
    entry_id integer primary key autoincrement,
    body text not null,
    title_cache varchar(255) not null,
    html_cache text not null,
    mtime integer unsigned,
    revision integer not null default 1
);

create table entry_history (
    entry_id integer primary key autoincrement,
    body text not null,
    ctime integer
) engine="innodb";

