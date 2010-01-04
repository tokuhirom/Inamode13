package Inamode13::DB::Row::Entry;
use strict;
use warnings;
use base qw/DBIx::Skinny::Row/;
use Text::MicroTemplate qw/encoded_string/;
use Time::Piece;
use Encode;

sub title { shift->title_cache }
sub html  { encoded_string(shift->html_cache) }
sub mtime_strftime { decode_utf8(Time::Piece->new($_[0]->mtime)->strftime($_[1])) }

1;
