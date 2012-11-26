package Talk::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Talk::Controller::Root - Root Controller for Talk

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my $talk = $c->model('DB::Talk')->first;
    $c->stash(talk => $talk);
}

use Talk::Form::Talk;
sub form :Local :Args(0) {
    my ( $self, $c ) = @_;
    my $talk = $c->model('DB::Talk')->new_result({});
    my $form = Talk::Form::Talk->new();
    my $result = $form->process(
        item => $talk,
        params => $c->req->params,
    );
    my $rendered_form = $form->render;
    $c->stash( template => \$rendered_form );
    if ($form->validated) {
        $c->res->redirect('/');
    }
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

David Schmidt,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
