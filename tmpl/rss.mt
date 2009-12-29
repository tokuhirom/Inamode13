? my ($entries) = @_;
? use HTTP::Date;
<?= encoded_string qq[<\?xml version="1.0" encoding="utf-8"?\>] ?>
<rss version="2.0"
     xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     xml:lang="ja">
  <channel>
    <title>Inamode13</title>
    <link>http://inamode.64p.org/</link>
    <description>Inamode13</description>
? for my $entry (@$entries) {
    <item>
      <title><?= $entry->title ?></title>
      <link>http://inamode.64p.org/entry/<?= $entry->entry_id ?></link>
      <description><![CDATA[<?= encoded_string $entry->html ?>]]></description>
      <pubDate><?= HTTP::Date::time2str($entry->mtime) ?></pubDate>
    </item>
? }
  </channel>
</rss>
