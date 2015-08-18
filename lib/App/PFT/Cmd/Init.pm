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
package App::PFT::Cmd::Init v0.03.2;

use strict;
use warnings;

use App::PFT qw/$Name $ConfName/;

use Exporter qw/import/;
our @EXPORT_OK = qw/$HOME_TEXT $TEMPLATE_HELP $TEMPLATE_TEXT/;

our $TEMPLATE_HELP = <<"EOF";
Templates directory
===================

This is the templates directory. Here $Name will search for the HTML
templates.

Content and templates
---------------------

Each content can optionally specify a custom template though the
`Template` configuration in the header. The default one is given by the
global configuration key `Template`, in `$ConfName`.

Unless differently specified in `$ConfName`, the default template is
`default.html`. An arguably decent default gets created automatically and
restored by `$Name init`.

How to write a template
-----------------------

For documentation about how to write a template, have a look at the manual
of the Template::Alloy perl library. Here follows a list of available keys:

- site
  - title
  - base_url
  - encoding
- site
  - encoding
- content
  - title
  - date { y, m, d }
  - links
    - prev { href, slug }
    - next { href, slug }
    - root { href, slug }
    - related (list of { href, slug })

EOF

our $HOME_TEXT = <<"EOF";

Welcome to this $Name site.

This page was auto-generated by the $Name Configurator.
EOF

our $TEMPLATE_TEXT = <<'EOF';
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=[% site.encoding %]">
  <title>[% site.title %] :: [% content.title %]</title>

    <style type="text/css">

        html {
            margin : 0;
            padding : 0;
            font-family : sans-serif;
        }

        body {
            margin : 0 auto 0;
            padding : 5em 5em 0;
            min-width : 40em;
            max-width : 50em;
            font-size : 10pt;
            line-height : 1.3em;
        }

        h1,h2,h3,h4,h5,h6 {
            line-height : 1em;
        }

        div#title {
            text-align : center;
        }

        a a:link a:visited {
            color : cornflowerblue;
            text-decoration : none;
        }

        a:hover {
            color : #87aced;
        }

        .side {
            float : right;
        }

        div#sitemap {
            margin-top : 3em;
            width : 30%;
        }

        div#sitemap h1 {
            font-size : 1em;
        }

        div#sitemap h2 {
            font-size : 1em;
            font-style : italic;
        }

        h1#sitetitle {
            margin-bottom : 1em;
            border-bottom : 1px solid cornflowerblue;
            text-align : right;
            clear : both;
        }

        div#pagetitle {
            margin : 2em 0 2em;
        }

        div#pagetitle h2 {
            font-size : 1em;
        }

        div#pagetitle h3 {
            font-size : 1em;
            display : inline;
            font-style : italic;
        }

        div#navigation ul {
            list-style-type : none;
        }

        div#navigation li h3 {
            display : inline;
        }

        div#content {
            font-family : serif;
            width : 65%;
        }

        div#content #title h1 {
            font-size : 2em;
        }

        div#content #text pre {
            overflow : auto;
            background : #ccc;
            padding : .5em;
        }

        div#content p img {
            max-width : 100%;
        }

        div#content h1,h2,h3,h4,h5,h6 { font-family : sans; }
        div#content h1 { font-size : 1.7em; }
        div#content h2 { font-size : 1.5em; }
        div#content h3 { font-size : 1.4em; }
        div#content h4 { font-size : 1.3em; }
        div#content h5 { font-size : 1.2em; }
        div#content h6 { font-size : 1.1em; }

        div#footer {
            color : silver;
            clear : right;
            margin-right : 0;
            margin-left : auto;
            font-size : .8em;
            text-align : left;
        }

    </style>
</head>

<body id="top">

<h1 id="sitetitle">[% site.title %]</h1>

<div id="sitemap" class="side">
  <h1>Site Map:</h1>

  [% IF links.pages %]
  <h2>Pages:</h2>
  <ul>
    [% FOREACH p = links.pages %]
      <li><a href="[% p.href %]">[% p.slug %]</a></li>
    [% END %]
  </ul>
  [% END %]

  [% IF links.backlog %]
  <h2>Last 5 entries:</h2>
  <ul>
    [% FOREACH e = links.backlog; IF loop.count > 5 BREAK END %]
      <li>
        <a href="[% e.href %]">
          [% e.slug %]
        </a>
      </li>
    [% END %]
  </ul>
  [% END %]

  [% IF links.months %]
  <h2>Last 5 months:</h2>
  <ul>
    [% FOREACH m = links.months; IF loop.count > 5 BREAK END %]
      <li>
        <a href="[% m.href %]">[% m.slug %]</a>
      </li>
    [% END %]
  </ul>
  [% END %]

  [% IF links.tags %]
  <h2>All the tags</h2>
  <ul>
    [% FOREACH t = links.tags %]
      <li>
        <a href="[% t.href %]">[% t.slug %]</a>
      </li>
    [% END %]
  </ul>
  [% END %]

</div>

<div id="pagetitle">
  <h1>[% content.title %]</h1>
  [% IF content.date %]
  <h2>
      <a href="[% links.root.href %]">[% content.date.y %] / [% content.date.m %]</a> / [% content.date.d %]
  </h2>
  [% END %]
</div>

<div id="navigation">
  <ul>
    [% IF links.prev %]
    <li>
      <h3>Prev:</h3>
      <a href="[% links.prev.href %]">[% links.prev.slug %]</a>
    </li>
    [% END %]

    [% IF links.next %]
    <li>
      <h3>Next:</h3>
      <a href="[% links.next.href %]">[% links.next.slug %]</a>
    </li>
    [% END %]

    [% IF content.tags %]
    <li>
      <h3>Tags:</h3>
      <ul>
        [% FOREACH t = content.tags %]
          <li><a href="[% t.href %]">[% t.slug %]</a></li>
        [% END %]
      </uL>
    </li>
    [% END %]
  </ul>
</div>

<div id="content">
  <div id="text">
    [% content.html %]

    [% IF links.related %]
    <ul>
      [% FOREACH l = links.related %]
        <li>
        [% IF l.date %]
          [% l.date.y %] / [% l.date.m %] / [% l.date.d %]:
        [% ELSE %]
          Page:
        [% END %]
        <a href="[% l.href %]">[% l.slug %]</a></li>
      [% END %]
    </ul>
    [% END %]
  </div>
</div>

<div id="footer">
    <a href="#top">Back</a>
</div>

</body>
</html>
EOF
