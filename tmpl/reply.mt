? my ($entry, $quote) = @_;
? extends 'base.mt';
? block title => "editing '" . $entry->title . "' - Inamode13";
? block header_part => q{<meta name="robots" content="noindex" />};

? block content => sub {

<div class="page-description">Reply to '<?= $entry->title ?>'</div>

<div class="form-container">
    <form method="post" action="/entry/<?= $entry->entry_id ?>/edit">
        <p class="nm"><textarea name="body" rows="10" cols="80"><?= $quote ?></textarea></p>
        <p class="nm submit-btn"><input type="submit" value="post" /></p>
    </form>
</div>

? };
