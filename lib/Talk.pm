package Talk;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    ConfigLoader
    Static::Simple
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    Unicode::Encoding
    StackTrace
    +CatalystX::Resource
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in talk.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Talk',

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header                      => 1,   # Send X-Catalyst header
    'Plugin::Session' => { flash_to_stash => 1 },
    'View::HTML'      => {
        TEMPLATE_EXTENSION => '.tt',
        render_die         => 1,
        INCLUDE_PATH       => [ __PACKAGE__->path_to(qw/ root templates /) ],
        WRAPPER            => 'wrapper.tt',
        ENCODING           => 'utf-8',
    },
    'Model::DB' => {
        schema_class => 'Talk::Schema',
        connect_info => {
            dsn => 'dbi:SQLite:dbname=' . __PACKAGE__->path_to('talk.db'),
            sqlite_unicode => 1,
        },
    },
    'CatalystX::Resource' => {
        controllers => [
            qw/
              Talk
              Slide
              /
        ]
    },
    'Controller::Talk' => {
        resultset_key => 'talks_rs',
        resources_key => 'talks',
        resource_key  => 'talk',
        form_class    => 'Talk::Form::Talk',
        model         => 'DB::Talk',
        redirect_mode => 'list',
        actions       => {
            base => {
                Chained  => '/',
                PathPart => 'talk',
            },
        },
    },
    'Controller::Slide' => {
        parent_key       => 'talk',
        parents_accessor => 'slides',
        resultset_key    => 'slides_rs',
        resources_key    => 'slides',
        resource_key     => 'slide',
        form_class       => 'Talk::Form::Slide',
        model            => 'DB::Slide',
        traits           => ['Sortable'],
        redirect_mode    => 'show_parent',
        actions          => {
            base => {
                Chained  => '/talk/base_with_id',
                PathPart => 'slide',
            },
        },
    },
);

# Start the application
__PACKAGE__->setup();


=head1 NAME

Talk - Catalyst based application

=head1 SYNOPSIS

    script/talk_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Talk::Controller::Root>, L<Catalyst>

=head1 AUTHOR

David Schmidt,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
