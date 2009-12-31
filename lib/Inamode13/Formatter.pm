package Inamode13::Formatter;
use strict;
use warnings;
use utf8;

our $URL_RE = qr{https?://[-_.!~*'()a-zA-Z0-9;/?:@&=+\$,%#]+};

sub new {
    my ($class, %args) = @_;
    bless {
        header_level => 0,
        anchor_tmpl  => q{<a href="/entry/%d">&gt;&gt;%d</a>},
        %args,
    }, $class;
}

sub parse {
    my ($self, $src) = @_;
    my $res = '';
    my @lines = split /(?:\r\n|\r|\n)/, $src;
    for (my $i=0; $i<@lines; ) {
        if ($lines[$i] =~ /^(\*{1,4})\s*(.+)$/) {
            my $level = length($1) + $self->{header_level};
            $res .= sprintf "<h$level>%s</h$level>\n", $self->_escape_stmt($2);
            ++$i;
        } elsif ($lines[$i] =~ /^>\|([a-z0-9]+)?\|$/) {
            my $pre_class = $1 ? "prettyprint lang-$1"  : 'prettyprint';
            $res .= qq{<pre class="$pre_class">};    ++$i; # '>||'
            while (@lines > $i && $lines[$i] ne '||<') {
                $res .= $self->_escape_stmt($lines[$i]) . "\n";
                ++$i;
            }
            $res .= "</pre>\n"; ++$i; # '||<'
        } elsif ($lines[$i] =~ /^([-+])/) {
            my $mark = $1;
            my $tag = {
                '+' => 'ol',
                '-' => 'ul',
            }->{$mark} or die "err";
            $mark = quotemeta($mark);

            my $level = 0;
            while (@lines > $i && $lines[$i] =~ /^($mark+)\s*(.+)$/) {
                if (length($1) > $level) {
                    if ($level == 0) {
                        $res .= "<$tag>\n";
                        $level++;
                    }
                    $res .= "<li><$tag>\n" x (length($1)-$level);
                } elsif (length($1) < $level) {
                    $res .= "</$tag></li>" x ($level-length($1));
                }
                $level = length($1);
                $res .= sprintf "<li>%s</li>\n", $self->_escape_stmt($2);
                ++$i;
            }
            if ($level > 0) {
                if ($level > 1) {
                    $res .= "</$tag></li>\n" x ($level-1);
                }
                $res .= "</$tag>\n";
            }
        } else {
            $res .= $self->_escape_stmt($lines[$i]) . "<br />\n";
            ++$i;
        }
    }
    return $res;
}

sub _escape_stmt {
    my ($self, $str) = @_;
    $str =~ s!>>([0-9]+)|($URL_RE)|<img\s*src=['""]($URL_RE)['"]\s*/?>|([&><"'])!
        if ($1) {
            sprintf $self->{anchor_tmpl}, $1, $1;
        } elsif ($2) {
            sprintf q{<a href="%s">%s</a>}, _escape_html($2), _escape_html($2);
        } elsif ($3) {
            sprintf q{<img src="%s" />}, _escape_html($3);
        } elsif ($4) {
            _escape_html($4)
        }
    !ge;    #' for poor editors
    return $str;
}

our %_escape_table = ( '&' => '&amp;', '>' => '&gt;', '<' => '&lt;', q{"} => '&quot;', q{'} => '&#39;' );
sub _escape_html {
    local $_ = $_[0];
    s!([&><"'])!$_escape_table{$1}!ge;
    $_;
}

1;
__END__

=head1 SYNOPSIS

    use Text::EseHatena;
    my $eh = Text::EseHatena->new();
    my $html = $eh->parse(<<'...');
    * hoge
    fuga
    - hige
    - moge
    ...
    print $html;

