#!/usr/bin/perl
#
require Modern::Perl;
require Module::Build;
#require Module::Build::ConfigData;

my $build = Module::Build->new
( module_name           => 'Data2any::Xml'
, dist_name             => 'Data2any-Xml'
, abstract              => 'Module to do something interresting'
, author                => 'marcel <marcel@some-provider.com>'

, license               => 'Perl_5'
, create_licence        => 0            # License is generated independently

, release_status        => 'stable'

, tap_harness_args      => { timer => 1
#                           , verbosity => 1
                           , failures => 1
                           , show_count => 1
                           }
, extra_manify_args     => { utf8 => 1 }


, requires =>
  { 'AppState'                                  => 'v0.4.15'
  , 'Modern::Perl'                              => '1.20140107'
  , 'Moose'                                     => '2.1204'
  , 'namespace::autoclean'                      => '0.15'
  , 'version'                                   => '0.9908'
  }

, test_requires =>
  { 'AppState'                                  => 'v0.4.15'
  , 'File::Path'                                => '2.08_01'
  , 'Modern::Perl'                              => '1.20140107'
  , 'Test::More'                                => '0.98'
  }
);

$build->create_build_script();


