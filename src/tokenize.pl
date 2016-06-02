#!/usr/bin/perl

my $printNewLine = $ARGV[0];

while(<STDIN>) {
    s/\s['`"]+\s+/ /g;
    s/\s['`"](\S)/ $1/g;
    s/['`"]\s/ /g;
    s/\s[\(\)\[\]!\"\&\|\=\/\:\?\%\+\;\$\*\>\<\{\#\~\@\}\^\_\`]+\s/ /g;
    s/\s+\.+\s+/ /g;
    s/\s+,\s+/ /g;
    s/\s+[\)\(]+\s+/ /g;
    s/\s+/ /g;
    #French
    s/’/'/g;
    s/([qQ]u|\s[CcLlMmTtSsDd])(['])(\S)/$1$2 $3/g;

    s/É/é/g;
    s/À/à/g;
    s/È/è/g;
    s/Ç/ç/g;
    s/Â/â/g;
    s/Ô/ô/g;
    s/Î/î/g;
    s/Ù/ù/g;
    s/Ú/ú/g;
    print lc($_);
    if ($printNewLine =~ m/yes/) {
	print "\n";
    }
}
