package Talk::Schema::Result::Slide;
use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('slides');
__PACKAGE__->add_columns(
    id => {
        data_type         => 'int',
        is_numeric        => 1,
        is_auto_increment => 1
    },
    title   => { data_type => 'varchar' },
    content => { data_type => 'varchar' },
    talk_id => {
        data_type  => 'int',
        is_numeric => 1,
    },

);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    'talk',
    'Talk::Schema::Result::Talk',
    'talk_id'
);

1;
