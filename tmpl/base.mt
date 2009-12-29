<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title><? block title => 'Amon' ?></title>
    <link href="<?= uri_for('/static/css/main.css') ?>" rel="stylesheet" type="text/css" media="screen" />
    <? block header_part => '' ?>
</head>
<body>
    <div class="wrapper">
        <div class="header">
            <div class="logo"><a href="<?= uri_for('/') ?>"><img src="<?= uri_for('/static/img/logo.png') ?>" alt="Inamode13" height="97" width="525" /></a></div>
            <div class="site-description">anonymous bbs, blog, wiki?</div>
        </div>
        <? block content => 'body here' ?>
    </div>
</body>
</html>
