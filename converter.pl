use strict;
use warnings;
use Text::Markdown 'markdown';
use File::Slurp;
use File::Find::Rule;

my $template = read_file 'index.tt';

for my $file ( File::Find::Rule->file()->name('*.md')->in( $ARGV[0] ) ) {
    my $html = markdown( scalar read_file($file) );
    write_file $file =~ s/^.*?\/(\w+)\.md$/$1.html/r, $template =~ s/##content##/$html/r;
}

