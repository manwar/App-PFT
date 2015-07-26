# Copyright 2014 - Giovanni Simoni
#
# This file is part of PFT.
#
# PFT is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# PFT is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with PFT.  If not, see <http://www.gnu.org/licenses/>.
#
package App::PFT::Cmd::Make;

=head1 NAME

pft compile

=head1 SYNOPSYS

pft compile ...

=cut

use strict;
use warnings;

use Exporter qw/import/;
use feature qw/say/;

use Pod::Usage;
use Pod::Find qw/pod_where/;

use Getopt::Long;
use File::Spec::Functions qw/catdir catfile no_upwards/;
use File::Path qw/make_path/;

use App::PFT::Struct::Conf qw/
    $ROOT
    $SITE_TITLE
    $SITE_URL
    $SITE_HOME
    $OUTPUT_ENC
/;
use App::PFT::Struct::Tree;
use App::PFT::Output::HTML;
use App::PFT::Util qw/ln/;

Getopt::Long::Configure ("bundling");

sub inject {
    my $tree = shift;
    my $inject = $tree->dir_inject;
    App::PFT::Util::ln
            catfile($inject, $_),
            catfile($tree->dir_build, $_),
            1
        foreach
            no_upwards
            map { substr($_, 1 + length $inject) }
        (
            glob(catfile $inject, '*'),
            glob(catfile $inject, '.*'),
        )
}

sub main {
    my $preview;
    GetOptions(
        'preview|p!' => \$preview,
        'help|h' => sub {
            pod2usage
                -exitval => 1,
                -verbose => 2,
                -input => pod_where({-inc => 1}, __PACKAGE__)
            ;
        }
    ) or exit 1;

    my $tree = App::PFT::Struct::Tree->new(
        basepath => $ROOT
    );

    my @pages = $tree->list_pages;
    my @entries = sort $tree->list_entries;
    my $months = $tree->link_months;

    App::PFT::Output::HTML->new(
        site_title => $SITE_TITLE,
        site_home => $SITE_HOME,
        # site_footer => $ENV{SITE_FOOTER},
        base_url => $preview ? $tree->dir_build : $SITE_URL,
        outputenc => $OUTPUT_ENC || 'utf-8',

        tree => $tree,
    )->build;

    inject $tree;
}

1;
