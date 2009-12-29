package Inamode13::Formatter;
use strict;
use warnings;
use utf8;
use 5.010;
use constant {
    MODE_NORMAL => 0,
    MODE_LI     => 1,
    MODE_PRE    => 2,
    MODE_P      => 3,
};

sub new {
    my ($class, %args) = @_;
    bless {header_level => 0, %args}, $class;
}

sub parse {
    my ($self, $src) = @_;
    my $res = '';
    my $mode = MODE_NORMAL;
    my $li_level = 0;
    for my $line (split /\n/, $src) {
        if (($mode == MODE_NORMAL || $mode == MODE_P || $mode == MODE_LI) && $line =~ qr{^(-+)\s*(.+)$}) {
            if ($mode == MODE_P) {
                $res .= "</p>\n";
            }
            if (length($1) > $li_level) {
                if ($li_level == 0) {
                    $res .= "<ul>\n";
                    $li_level++;
                }
                $res .= "<li><ul>\n" x (length($1)-$li_level);
            } elsif (length($1) < $li_level) {
                $res .= "</ul></li>" x ($li_level-length($1));
            }
            $li_level = length($1);
            $res .= sprintf "<li>%s</li>\n", escape_html($2);
            $mode = MODE_LI;
        } else {
            if ($li_level > 0) {
                if ($li_level > 1) {
                    $res .= "</ul></li>\n" x ($li_level-1);
                }
                $res .= "</ul>\n";
                $li_level = 0;
                $mode = MODE_NORMAL;
            }
            given ([$mode, $line]) {
                when ([MODE_NORMAL, qr{^(\*+)\s*(.+)$}]) {
                    my $level = length($1) + $self->{header_level};
                    $res .= sprintf "<h$level>%s</h$level>\n", escape_html($2);
                }
                when ([MODE_P, '>||']) {
                    $_->[0] = $mode = MODE_NORMAL;
                    $res .= "</p>\n";
                    continue;
                }
                when ([MODE_NORMAL, '>||']) {
                    $mode = MODE_PRE;
                    $res .= "<pre>";
                }
                when ([MODE_PRE, '||<']) {
                    $mode = MODE_NORMAL;
                    $res .= "</pre>";
                }
                when ([MODE_PRE, qr{(.*)}]) {
                    $res .= escape_html($1) . "\n";
                }
                when ([MODE_P, '']) {
                    $res .= '</p>';
                }
                when ([MODE_P, qr{(.*)}]) {
                    $res .= escape_html($line);
                }
                when ([MODE_NORMAL, qr{(.*)}]) {
                    $mode = MODE_P;
                    $res .= '<p>' . escape_html($line);
                }
                default {
                    die "SHOULD NOT REACHE HERE: $mode, '$line'";
                }
            }
        }
    }
    if ($li_level > 0) {
        $res .= "</ul>" x $li_level;
        $li_level = 0;
    }
    if ($mode == MODE_P) {
        $res .= "</p>";
    }
    $res =~ s{<p></p>}{}g;
    return $res;
}

our %_escape_table = ( '&' => '&amp;', '>' => '&gt;', '<' => '&lt;', q{"} => '&quot;', q{'} => '&#39;' );
sub escape_html {
    my $str = shift;
    return ''
      unless defined $str;
    $str =~ s/([&><"'])/$_escape_table{$1}/ge;    #' for poor editors
    return $str;
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

