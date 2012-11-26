package Talk::Schema::Result::Slide;
use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/ Ordered Core /);
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
    position => { data_type => 'int' }, 
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->position_column('position');
__PACKAGE__->grouping_column('talk_id');
__PACKAGE__->resultset_attributes({ order_by => [qw/ talk_id position /] });

__PACKAGE__->belongs_to(
    'talk',
    'Talk::Schema::Result::Talk',
    'talk_id'
);

1;
