requires 'Catalyst::Runtime' => '5.90016';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General';
requires 'CatalystX::Resource';
requires 'CatalystX::SimpleLogin';
requires 'Catalyst::Plugin::Authentication';
requires 'DBIx::Class';
requires 'Config::Any::Perl';

on 'test' => sub {
    requires 'Test::More' => '0.88';
};
