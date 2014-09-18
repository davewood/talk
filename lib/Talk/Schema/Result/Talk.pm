package Talk::Schema::Result::Talk;
use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('talks');
__PACKAGE__->add_columns(
    id => {
        data_type         => 'int',
        is_numeric        => 1,
        is_auto_increment => 1
    },
    title   => { data_type => 'varchar' },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
    'slides',
    'Talk::Schema::Result::Slide',
    'talk_id',
);

__PACKAGE__->resultset_class('Talk::Schema::ResultSet::Talk');

1;
