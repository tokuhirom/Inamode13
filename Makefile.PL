use inc::Module::Install;
all_from "lib/Inamode13.pm";

tests 't/*.t t/*/*.t t/*/*/*.t';
requires 'Amon';
recursive_author_tests('xt');

WriteAll;
