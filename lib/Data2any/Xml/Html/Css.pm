package Data2any::Xml::Html::Css;

use Modern::Perl;
use version; our $VERSION = '' . version->parse("v0.0.1");
use 5.014003;

use Moose;
use WebService::Validator::CSS::W3C;

extends qw(Data2any::Aux::BlessedStructTools AppState::Plugins::Log::Constants);

#-------------------------------------------------------------------------------
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
  
  my $parent_node = $self->get_data_item('parent_node');
  my $head = $parent_node->xpath('/html/head');
  
  if( !defined $head )
  {
    my $html = $parent_node->xpath('/html');
    $head = $self->mk_node( 'head', $html);
  }
  
  my $style = $head->xpath('style') // $self->mk_node( 'style', $head);
  my $text_node = $style->xpath('text()') // AppState::Plugins::NodeTree::NodeText->new;
  say "Text: $text_node";
  
  # Test of the css text from location
  #
  my $text =<<'EOTXT';

.A4-Paper
{
  /* The page must be defined on its outside maximum values */
  box-sizing:      border-box;

  /* Sizes of A4 type page size. Margins of wkhtmltopdf must be set to 0
     to use the values like this. Use padding to specify the print margin
  */
  width:           210mm;
#       height:          297mm;
  height:          297.2mm;

  /* Everything outside the page will disappear */
#       text-overflow:   ellipsis;
  overflow:        hidden;

  word-wrap:       break-word;
  text-wrap:       suppress;
  text-rendering:  optimizeLegibility;
#       -webkit-font-smoothing: pixel-antialiased;

  /* Inside area which is the printable area. wkhtmltopdf has the default
     of 10mm from the edge.
  */
  padding:         10mm;
  margin:          0;

  border-width:    1px;
  bolder-color:    #ff0055;
  border-style:    solid;
}



/* Font definitions */
@font-face
{ font-family:       Pamela;
  font-style:        normal;
  src:               url('http://localhost/I/Fonts/Pamela.ttf') format('truetype');
}

body
{ margin:            0;
  font-family:       Arial, sans-serif;
}

.weird3
{ font-family:       Pamela;
  font-size:         25px;
  color:             #777;
}

EOTXT

  $text_node->value($text);
  $style->link_with_node($text_node);

#  say "Head: $head, ", $head->name;
}
