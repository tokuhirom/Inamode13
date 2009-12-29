? my ($entry) = @_;
? extends 'base.mt';

? block content => sub {
<div class="form-container">
    <form method="post" action="/entry/<?= $entry->entry_id ?>/edit">
        <p class="nm"><textarea name="body" rows="10" cols="80"><?= $entry->body ?></textarea></p>
        <p class="nm submit-btn"><input type="submit" value="post" /></p>
    </form>
</div>
? };
