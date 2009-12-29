use strict;
use warnings;
use Inamode13::Formatter;
use Test::Base;

sub format {
    Inamode13::Formatter->new()->parse(shift);
}

filters {
    input    => [qw/format chomp/],
    expected => [qw/chomp/],
};

run_is input => 'expected';

__END__

===
--- input
* Amon TODO

- param_decoded()
- mobile support
ka
--- expected
<h1>Amon TODO</h1>

<ul>
<li>param_decoded()</li>
<li>mobile support</li>
</ul>
<p>ka</p>
