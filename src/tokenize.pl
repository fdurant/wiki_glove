#!/usr/bin/perl

$/ = "</doc>";

while(<>) {
    s/<doc.*?>//mg;
    s/<\/doc>//mg;
    s/[\(\)\[\]\\.,!\"]//mg;
    s/\s+/ /g;
    print lc($_);
}
