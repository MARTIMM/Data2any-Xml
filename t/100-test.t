use Modern::Perl;

use Test::More;

use AppState;
require File::Path;

#-------------------------------------------------------------------------------
# Init
#
my $app = AppState->instance;
$app->use_work_dir(0);
$app->use_temp_dir(0);
$app->initialize( config_dir => 't/100-Test');
$app->check_directories;


my $log = $app->get_app_object('Log');
#$log->show_on_error(0);
#$log->show_on_warning(1);
#$log->do_append_log(0);
#$log->do_flush_log(1);

$log->start_logging;

$log->file_log_level($log->M_ERROR);

$log->add_tag('100');

#-------------------------------------------------------------------------------
# Start testing
#
BEGIN { use_ok('Data2any::Xml') };

#...

#-------------------------------------------------------------------------------
# Cleanup and exit
#
done_testing();
$app->cleanup;

File::Path::remove_tree( 't/100-Test', {verbose => 1});


