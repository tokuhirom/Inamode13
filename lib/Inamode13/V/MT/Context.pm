package Inamode13::V::MT::Context;
use Amon::V::MT::Context;

sub permalink {
    my $entry = shift;
    $entry->{__permalink_cache} ||= do {
        my $base = req->base()->clone();
        $base->path(uri_for("/entry/@{[ $entry->entry_id ]}"));
        $base->as_string;
    };
}

1;
