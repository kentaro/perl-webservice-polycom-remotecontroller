package WebService::Polycom::RemoteController::Result::Command;
use Any::Moose;

has 'status'  => (is => 'rw', isa => 'Str');
has 'command' => (is => 'rw', isa => 'Str');
has 'message' => (is => 'rw', isa => 'Str');

no Any::Moose;
__PACKAGE__->meta->make_immutable;

sub is_success {
    my $self = shift;
    $self->status eq 'success' &&
    $self->message !~ /^error:/i;
}

sub is_error { !shift->is_success }

!!1;
