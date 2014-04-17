package Data2any::Xml;

use Modern::Perl;
use version; our $VERSION = qv('v0.0.1');
use v5.16.3;

use namespace::autoclean;
use Moose;
extends qw(AppState::Ext::Constants);

use AppState;

#...

sub BUILD
{
  my($self) = @_;

  if( $self->meta->is_mutable )
  {
    $self->code_reset;
#    $self->const( 'C_SOMECONST0', qw( M_F_INFO M_SUCCESS));
#    $self->const( 'C_SOMECONST1', qw( M_F_ERROR M_FAIL));
#    $self->const( 'C_SOMECONST2', qw( M_WARNING M_FORCED));

    __PACKAGE__->meta->make_immutable;
  }
}

#...

# End of package
#
1;

__END__

=head1 NAME

Data2any::Xml - Module to do something interresting

=head1 VERSION

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 LICENSE AND COPYRIGHT

=cut

