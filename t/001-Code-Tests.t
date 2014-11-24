# Testing all modules for syntax errors
#
use Modern::Perl;
use Test::Most;

use_ok('Data2any::Xml');
use_ok('Data2any::Xml::Html::List::Ol');
use_ok('Data2any::Xml::Html::Css');
use_ok('Data2any::Xml::Html::LinkFile');
#use_ok('Data2any::Xml');
#use_ok('Data2any::Xml');
#use_ok('Data2any::Xml');
#use_ok('');
#use_ok('');
#use_ok('');

done_testing();
exit(0);
