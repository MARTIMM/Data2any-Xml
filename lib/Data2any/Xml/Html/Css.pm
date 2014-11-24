package Data2any::Xml::Html::Css;

use Modern::Perl;
use version; our $VERSION = '' . version->parse("v0.0.1");
use 5.014003;

use Moose;
use WebService::Validator::CSS::W3C;

extends qw(Data2any::Aux::BlessedStructTools AppState::Plugins::Log::Constants);
use AppState::Plugins::Log::Meta_Constants;

#-------------------------------------------------------------------------------
def_sts( 'E_NOMODE',    'M_ERROR', 'No mode defined or recognized');
def_sts( 'E_NOFILE',    'M_ERROR', 'No file defined for mode link_to_file');
def_sts( 'E_STOREDFD',   'M_ERROR', 'Storage already defined (%s)');

#-------------------------------------------------------------------------------
#
has filename =>
    ( is                => 'rw'
    , isa               => 'Str'
    );

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
  
  my $nd = $self->get_data_item('node_data');

  my $parent_node = $self->get_data_item('parent_node');
  my $head_node = $parent_node->xpath('/html/head');
  
  if( !defined $head_node )
  {
    my $html_node = $parent_node->xpath('/html');
    $head_node = $self->mk_node( 'head', $html_node);
  }

  # Check the mode of the action; link_to_file, inline or css_rule. The first
  # two are mode to store the css in some way. The third specifies rules.
  #
  my $mode = $nd->{mode} // '';
  if( $mode eq 'link_to_file' )
  {
    # Check if a stora type mode has been used before
    #
    my $st_type = $head_node->get_global_data('css_store_mode') // '';    
    if( $st_type )
    {
      return $self->log($self->E_STOREDFD, [$st_type]);
    }

    else
    {
      # <link rel="stylesheet" href="file" />
      #
      my $file = $nd->{file} // '';
      my $url = $nd->{url} // $file;
      if( $file )
      {
        my $link_node = $self->mk_node( 'link'
                                      , $head_node
                                      , { rel => 'stylesheet'
                                        , href => $url
                                        }
                                      );
        $head_node->set_global_data(css_store_mode => $mode);
        $self->filename($file);

        # Store this object in the html node so as to run the 'down' handler
        # when traversing the tree on its last visit to the html node.
        #
        my $html_node = $parent_node->xpath('/html');
        $html_node->set_object(css_object_down => $self);
say "Set object down on head";
      }

      else
      {
        return $self->log($self->E_NOFILE);
      }
    }
  }

  elsif( $mode eq 'inline' )
  {
    my $st_type = $head_node->get_global_data('css_store_mode') // '';
    if( $st_type )
    {
      return $self->log($self->E_STOREDFD, [$st_type]);
    }

    else
    {
      # <style>...css text...</style>
      #
      my $style_node = $head_node->xpath('style')
                         // $self->mk_node( 'style', $head_node);
      $head_node->set_global_data(css_store_mode => $mode);

      # Insert an empty style text.
      #
      my $text_node = $style_node->xpath('text()')
                        // AppState::Plugins::NodeTree::NodeText->new;
say "Text: $text_node";

      $text_node->value('');
      $style_node->link_with_node($text_node);

      # Store this object in the style node so as to run the 'up' handler
      # when traversing the tree on its first visit to the style node.
      #
say "Set object up on style";
      $style_node->set_object(css_object_up => $self);
    }
  }
    
  elsif( $mode eq 'css_rule' )
  {

  }

  else
  {
    return $self->log($self->E_NOMODE);
  }
  

#  say "Head: $head, ", $head->name;
}

#-------------------------------------------------------------------------------
# Handler called when going up on the style node. Before letting the traversal
# of the tree going further add a text as a child to the style node.
#
sub handler_up
{
  my( $self, $style_node, $object_key) = @_;

say "Up andler, $object_key, node=", $style_node->name;
  if( $object_key eq 'css_object_up' )
  {
    my $text_node = $style_node->xpath('text()');
say "Text: $text_node";

    # Test of the css text from location
    #
    my $text = $self->_get_css_text;

    $text_node->value($text);
    $style_node->link_with_node($text_node);
  }
}

#-------------------------------------------------------------------------------
# Down handler will be run on the last visit of the html tag to save all
# accumulated css rules into a file
#
sub handler_down
{
  my( $self, $html_node, $object_key) = @_;
  
say "Down handler, $object_key, node=", $html_node->name;
  if( $object_key eq 'css_object_down' )
  {
    my $nd = $self->get_data_item('node_data');
    open my $css_file, '>', $nd->{file};
    say $css_file $self->_get_css_text;
    close $css_file;
  }
}

#-------------------------------------------------------------------------------
#
sub _get_css_text
{
  return <<'EOTXT';

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
}

#-------------------------------------------------------------------------------
__PACKAGE__->meta->make_immutable;
1;

__END__

