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
package App::PFT::Cmd::Publish;

use strict;
use warnings;

use Exporter qw/import/;
use feature qw/say state/;

use Pod::Usage;
use Pod::Find qw/pod_where/;

use File::Spec::Functions qw/catfile/;
use File::Path qw/make_path remove_tree/;
use File::Copy::Recursive;

use App::PFT::Struct::Conf qw/$ROOT %REMOTE/;
use App::PFT::Struct::Tree;

use Carp;

use Getopt::Long;
Getopt::Long::Configure 'bundling';

sub check {
    foreach (@_) {
        croak "Cannot use $REMOTE{Method}: missing Remote.$_ in pft.yaml"
            unless defined $REMOTE{$_}
    }
}

sub rsync_ssh {
    my $tree = shift;

    check qw/User Host Path/;

    my $src = catfile($tree->dir_build, '');
    my $dst = "$REMOTE{User}\@$REMOTE{Host}:$REMOTE{Path}";
    my $port = $REMOTE{Port} || 22;

    local $, = "\n\t";
    say STDERR 'Sending with RSync', "from $src", "to $dst";


    system('rsync',
        '-e', "ssh -p $port",
        '--recursive',
        '--verbose',
        '--copy-links',
        '--times',
        '--delete',
        '--human-readable',
        '--progress',
        $src, $dst,
    );
}

sub todir {
    state $relative = do {
        my $sup = File::Spec::Functions::updir;
        qr/^$sup/;
    };
    my $tree = shift;

    check qw/Path/;

    my $dst = $REMOTE{Path} =~ /$relative/
        ? catfile($tree->basepath, $REMOTE{Path})
        : $REMOTE{Path}
        ;

    remove_tree $dst;
    make_path $dst, { verbose => 1 };

    local $File::Copy::Recursive::CopyLink = 0;
    File::Copy::Recursive::rcopy_glob(
        catfile($tree->dir_build, '*'),
        $dst,
    );
}

sub main {
    GetOptions(
        'help|h' => sub {
            pod2usage
                -exitval => 1,
                -verbose => 2,
                -input => pod_where({-inc => 1}, __PACKAGE__)
            ;
        }
    ) or exit 1;

    my $method = {
        'rsync+ssh' => \&rsync_ssh,
        'todir' => \&todir,
    }->{$REMOTE{Method}};
    die 'Unknown method ', $REMOTE{Method} unless $method;

    my $tree = App::PFT::Struct::Tree->new( basepath => $ROOT);
    $method->($tree);
}

1;
