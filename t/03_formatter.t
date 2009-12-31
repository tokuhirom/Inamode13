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

=== h
--- input
* Amon
** h2
--- expected
<h1>Amon</h1>
<h2>h2</h2>

=== pre
--- input
foo
>||
bar
bos
||<
baz
>|perl|
use strict;
||<
biz
--- expected
foo<br />
<pre class="prettyprint">bar
bos
</pre>
baz<br />
<pre class="prettyprint lang-perl">use strict;
</pre>
biz<br />

===
--- input
* Amon TODO

- param_decoded()
- mobile support
ka
--- expected
<h1>Amon TODO</h1>
<br />
<ul>
<li>param_decoded()</li>
<li>mobile support</li>
</ul>
ka<br />

=== anchor
--- input
>>1
--- expected
<a href="/entry/1">&gt;&gt;1</a><br />

=== ol
--- input
+ foo
++ bar
--- expected
<ol>
<li>foo</li>
<li><ol>
<li>bar</li>
</ol></li>
</ol>

=== link
--- input
http://google.com
<img src="http://www.google.co.jp/intl/ja_jp/images/logo.gif" />
--- expected
<a href="http://google.com">http://google.com</a><br />
<img src="http://www.google.co.jp/intl/ja_jp/images/logo.gif" /><br />
