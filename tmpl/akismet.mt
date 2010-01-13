? my ($entries, $page, $has_next) = @_;
? extends 'base.mt';
? block title => 'ARE YOU SPAMMER? - inamode13';

? block content => sub {

<div class="page-description">Your post is looks like a spam!</div>

<div class="form-container">
    <form method="post" action="/entry">
        <p class="nm"><textarea name="body" rows="10" <? unless ((req->user_agent||'') =~ /iPhone/) { ?>cols="80"<? } ?>></textarea></p>
        <p class="nm submit-btn"><input type="submit" value="post" /></p>
    </form>
</div>

? };
