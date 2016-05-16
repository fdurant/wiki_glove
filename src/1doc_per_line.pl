#!/usr/bin/perl

$/ = "</doc>";

while(<>) {
    s/<doc.*?>//mg;
    s/<\/doc>//mg;
    s/[\n\r]+/ /g;
    print "$_\n";
}
