? my ($entries, $page, $has_next) = @_;
? extends 'base.mt';
? block title => 'inamode13';

? block content => sub {
<div class="form-container">
    <form method="post" action="/entry">
        <p class="nm"><textarea name="body" rows="10" cols="80"></textarea></p>
        <p class="nm submit-btn"><input type="submit" value="post" /></p>
    </form>
</div>

<div class="feed">
? for my $entry (@$entries) {
?=  render_partial('include/entry.mt', $entry);
    <hr />
? }
</div>
? };
