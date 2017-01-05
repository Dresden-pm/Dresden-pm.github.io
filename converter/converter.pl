use strict;
use warnings;
use Text::Markdown 'markdown';
use File::Slurp;
use File::Find::Rule;

my $template = read_file 'index.tt';

for my $file ( File::Find::Rule->file()->name('*.md')->in('.') ) {
    my $html = markdown( scalar read_file($file) );
    write_file $file =~ s/\.md$/.html/r, $template =~ s/##content##/$html/r;
}

