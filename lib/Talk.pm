package Talk;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    ConfigLoader
    Static::Simple
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    StackTrace
    +CatalystX::Resource
    +CatalystX::SimpleLogin
    Authentication
/;

extends 'Catalyst';

our $VERSION = '0.01';


__PACKAGE__->config(
    name                                        => 'Talk',
    encoding                                    => 'UTF-8',
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header                      => 1,
    'Plugin::Session'                           => { flash_to_stash => 1 },
    'View::HTML'                                => {
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
    'Plugin::Authentication' => {
        default => {
            credential => {
                class          => 'Password',
                password_field => 'password',
                password_type  => 'clear'
            },
            store => {
                class => 'Minimal',
                users => {
                    admin => {
                        password => '',
                    },
                },
            },
        },
    },
    'Controller::Login' => {
        login_form_args => {
            field_list => [ remember => { inactive => 1 } ],
        },
        login_form_class_roles => ['Talk::Role::Form'],
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
        resultset_key => 'talks',
        resource_key  => 'talk',
        form_class    => 'Talk::Form::Talk',
        model         => 'DB::Talk',
        redirect_mode => 'list',
        actions       => {
            base => {
                Chained  => '/login/required',
                PathPart => 'talk',
            },
        },
    },
    'Controller::Slide' => {
        parent_key       => 'talk',
        parents_accessor => 'slides',
        resultset_key    => 'slides',
        resource_key     => 'slide',
        form_class       => 'Talk::Form::Slide',
        model            => 'DB::Slide',
        traits           => ['Sortable'],
        redirect_mode    => 'show',
        actions          => {
            base => {
                Chained  => '/talk/base_with_id',
                PathPart => 'slide',
            },
        },
    },
);

__PACKAGE__->setup();
1;
