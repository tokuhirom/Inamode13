package Inamode13::Formatter;
use strict;
use warnings;
use utf8;

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
    my @lines = split /\n/, $src;
    for (my $i=0; $i<@lines; ) {
        if ($lines[$i] =~ /^(\*{1,4})\s*(.+)$/) {
            my $level = length($1) + $self->{header_level};
            $res .= sprintf "<h$level>%s</h$level>\n", $self->escape_html($2);
            ++$i;
        } elsif ($lines[$i] eq '>||') {
            $res .= "<pre>";    ++$i; # '>||'
            while (@lines > $i && $lines[$i] ne '||<') {
                $res .= $self->escape_html($lines[$i]) . "\n";
                ++$i;
            }
            $res .= "</pre>\n"; ++$i; # '||<'
        } elsif ($lines[$i] =~ /^(-+)\s*(.+)$/) {
            my $li_level = 0;
            while (@lines > $i && $lines[$i] =~ /^(-+)\s*(.+)$/) {
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
                $res .= sprintf "<li>%s</li>\n", $self->escape_html($2);
                ++$i;
            }
            if ($li_level > 0) {
                if ($li_level > 1) {
                    $res .= "</ul></li>\n" x ($li_level-1);
                }
                $res .= "</ul>\n";
            }
        } else {
            $res .= $self->escape_html($lines[$i]) . "<br />\n";
            ++$i;
        }
    }
    return $res;
}

our %_escape_table = ( '&' => '&amp;', '>' => '&gt;', '<' => '&lt;', q{"} => '&quot;', q{'} => '&#39;' );
sub escape_html {
    my ($self, $str) = @_;
    $str =~ s/>>([0-9]+)|([&><"'])/
        if ($2) {
            $_escape_table{$2}
        } elsif ($1) {
            sprintf $self->{anchor_tmpl}, $1, $1;
        }
    /ge;    #' for poor editors
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

