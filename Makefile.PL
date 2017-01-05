use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Dresden.pm Github page',
    PL_FILES           => {},
    CONFIGURE_REQUIRES => { 'ExtUtils::MakeMaker' => 0, },
    BUILD_REQUIRES     => {
        'Text::Markdown'   => 0,
        'File::Slurp'      => 0,
        'File::Find::Rule' => 0,
        'Sereal::Decoder'  => 0,
        'Sereal'           => 0,
        'MIME::Base64'     => 0,
    },
    PREREQ_PM => {},
);
