use inc::Module::Install;
all_from "lib/Inamode13.pm";

tests 't/*.t t/*/*.t t/*/*/*.t';
requires 'Amon' => 0.19;
requires 'List::MoreUtils';
requires 'Net::Akismet';
test_requires 'Test::mysqld';
recursive_author_tests('xt');

WriteAll;
