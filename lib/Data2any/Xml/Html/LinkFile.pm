package Data2any::Xml::Html::LinkFile;

use version; our $VERSION = '' . version->parse("v0.0.12");
use 5.014003;
#-------------------------------------------------------------------------------
use Modern::Perl;
use Moose;
extends qw(Data2any::Aux::BlessedStructTools AppState::Plugins::Log::Constants);

use AppState;
use AppState::Plugins::Log::Meta_Constants;
use AppState::Plugins::NodeTree::NodeText;

#-------------------------------------------------------------------------------
def_sts( 'E_NOTXTIMG',  'M_ERROR', 'No text or image to used with html link');
def_sts( 'E_REFNOTSUP', 'M_ERROR', 'Reference type %s not supported');

#-------------------------------------------------------------------------------
#has '+version' => ( default => $VERSION);

#-------------------------------------------------------------------------------
#
sub BUILD
{
  my($self) = @_;

  AppState->instance->log_init('LF');
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
#  my $cfg = AppState->instance->get_app_object('ConfigManager');

  # Get and check type
  #
  my $type = $nd->{type};
  $type //= 'href';

  # Generate a html reference to given url
  #
  if( $type eq 'href' )
  {
    # Get the variables to generate html link.
    #
    my $a_node;
    my $href = $nd->{reference};
    if( defined $href )
    {
      $a_node = $self->mk_node( 'a', $self->get_data_item('parent_node'));
      my $attr = {href => $href};
      $attr->{alt} = $nd->{alttext} if defined $nd->{alttext};
      $a_node->add_attribute(%$attr);

      # Is there an image ?
      #
      if( defined $nd->{image} and -r $nd->{image} )
      {
        my $img_node = $self->mk_node( 'img', $a_node);
        my $attr = {src => $nd->{image}};
        $attr->{alt} = $nd->{alttext} if defined $nd->{alttext};
        $img_node->add_attribute(%$attr);
      }

      # Or is there text ?
      #
      elsif( defined $nd->{text} and $nd->{text} )
      {
        my $text_node = AppState::Plugins::NodeTree::NodeText->new(value => $nd->{text});
        $a_node->link_with_node($text_node);
      }

      else
      {
        $self->log($self->E_NOTXTIMG);
      }
    }
  }

  else
  {
    $self->log( $self->E_REFNOTSUP, [$type]);
  }
}

#-------------------------------------------------------------------------------
no Moose;
1;

__END__

#-------------------------------------------------------------------------------
# Documentation
#

=head1 NAME

Data2any::Xml::Html::LinkFile - Generate html code to connect documents

=head1 SYNOPSIS

=over 2

=item * Example 1

  - !perl/Data2any::Xml::Html::LinkFile
     type: href
     alttext: file manager
     image: file_manager.png
     reference: y2x2.yml

=item * Example 2

  - !perl/Data2any::Xml::Html::LinkFile
     type: href
     text: google
     reference: http://google.com

=back

=head1 DESCRIPTION

The module is a module used in combination with the module L<Data2xml> which
converts data to any form of xml. This module can be used when a html link must
be generated or when some XML(as data) text must be included.

The following options can be used;

=over 2

=item * I<alttext>. Used when type is C<href> and image is defined. alttext is
then used in the html to be shown as an alternative in case the image cannot be
shown.

=item * I<class>. Used when type is C<href>. This will be an attribute in
the link and image html elements like <a class='...'>.

=item * I<id>. Used when type is C<href>. This will be an attribute in
the link and image html elements like <a id='...'>. Now id's are supposed to be
unique in a document so the id text gets an extra number attached to it. E.g.
when the it is 'abc' it will become something as 'abc_1', 'abc_2' etc.

=item * I<image>. Used when type is C<href>. The value is a url to the image
which will become clickable.

=item * I<reference>. This is the url for the href.

=item * I<text>. Used when type is C<href>. Text can be used instead of
using an image.

=item * I<type>. Type of usage. Type can be C<href>, C<include> and
C<includeThis>. Create a link. The example in the synopsis will translate into

=over 2

=item * I<href>. Create a link. The example in the synopsis will translate into
<a href='y2x2.yml' alt='file manager'><img src='file_manager.png' /></a>. This
will be the default.

=item * I<include>. Include a document from this or another file.

=item * I<includeThis>. Include a document from this file.

=back

=back


=head1 BUGS

No bugs yet.


=head1 SEE ALSO

  L<yaml2xml>   Program to translate YAML text into XML.
  L<Data2xml>   Module to translate any data into XML.


=head1 AUTHOR

Marcel Timmerman, E<lt>mt1957@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Marcel Timmerman

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.3 or,
at your option, any later version of Perl 5 you may have available.

=cut
