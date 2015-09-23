#!/usr/bin/perl -w

use warnings;
use strict;

use feature qw/say/;
use Test::More ;#tests => 30;

use Scalar::Util qw/refaddr/;

use Encode qw/encode/;

use File::Temp;
use File::Spec::Functions qw/catdir catfile/;

use IO::File;

use App::PFT::Struct::Tree;
use App::PFT::Data::Date;

use App::PFT::Struct::Conf qw/$INPUT_ENC/;
BEGIN { $INPUT_ENC = 'utf-8' }

sub same {
    my($x, $y) = map { refaddr $_ } @_;
    return $x == $y;
}

my $dir = File::Temp->newdir();

$App::PFT::Struct::Tree::Verbose = 0;
my $tree = App::PFT::Struct::Tree->new(
    basepath => "$dir"
);

# -------------------- Population of Site -------------------------------

my @pages;
for my $i (1 .. 4) {
    push @pages, $tree->entry(
        title => encode('utf-8', "Hello $i"),
        author => 'perl',
        date => App::PFT::Data::Date->new(
            year => 1,
            month => 2,
            day => $i,
        ),
    );
};

my $page = $tree->page(
    title => encode('utf-8', 'Hello 2'),
    author => 'perl',
);

# -------------------- Lookups ------------------------------------------

my $found;

$found = $tree->lookup(kind => 'page', hint => ['Hello', '2']);
ok same($found, $page), 'same';


done_testing()
