create table entry (
    entry_id integer primary key autoincrement,
    body text not null,
    title_cache varchar(255) not null,
    html_cache text not null,
    mtime integer unsigned
);
