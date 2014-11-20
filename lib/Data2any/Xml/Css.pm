package Data2any::Xml::Css;

use Modern::Perl;
use version; our $VERSION = '' . version->parse("v0.0.1");
use 5.014003;

use Moose;
use WebService::Validator::CSS::W3C;

#-------------------------------------------------------------------------------
#has '+version' => ( default => $VERSION);


#-------------------------------------------------------------------------------
#
sub BUILD
{
  my($self) = @_;

  AppState->instance->log_init('CSS');
}

#-------------------------------------------------------------------------------
# Called by AppState::Plugins::NodeTree tree builder after creating this object.
# This type of use doesn't need to return a value. After process() is done
# the current config file and current document can be changed into others.
#
sub process
{
  my($self) = @_;
  
  
}
