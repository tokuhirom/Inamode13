<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title><? block title => 'Amon' ?></title>
    <link rel="alternate" type="application/rss+xml" title="RSS" href="http://inamode.64p.org/index.rss" />
    <link href="<?= uri_for('/static/css/main.css') ?>" rel="stylesheet" type="text/css" media="screen" />
    <link type="text/css" rel="stylesheet" media="only screen and (max-device-width: 480px)" href="<?= uri_for('/static/css/iphone.css') ?>" />
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=yes" />
    <? block header_part => '' ?>
</head>
<body>
    <div class="wrapper">
        <div class="header">
            <div class="logo"><a href="<?= uri_for('/') ?>"><img src="<?= uri_for('/static/img/logo.png') ?>" alt="Inamode13" height="97" width="525" /></a></div>
            <div class="site-description">anonymous bbs, blog, wiki?</div>
        </div>
        <div class="body">
            <? block content => 'body here' ?>
        </div>
        <div class="footer">
            <p>Copyright (C) 2009 64p.org All rights reserved.</p>
            <p>Powered by <a href="http://perl.org/">Perl</a>, <a href="http://github.com/tokuhirom/Amon/">Amon</a></p>
            <p>
                <a href="http://validator.w3.org/check?uri=referer"><img
                    src="http://www.w3.org/Icons/valid-xhtml10-blue"
                    alt="Valid XHTML 2.0 Transitional" height="31" width="88" /></a>
                <a href="http://validator.w3.org/feed/check.cgi?url=http%3A//inamode.64p.org/index.rss"><img src="valid-rss.png" alt="[Valid RSS]" title="Validate my RSS feed" /></a>
            </p>
        </div>
    </div>
</body>
</html>
