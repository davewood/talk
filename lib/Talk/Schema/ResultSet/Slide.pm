package Talk::Schema::ResultSet::Slide;
use base 'DBIx::Class::ResultSet';
use strict;
use warnings;

sub default_order {
    my ($self) = @_;
    my $alias = $self->current_source_alias;
    return $self->search_rs(
        undef,
        {
            order_by => { -asc => ["$alias.talk_id", "$alias.position"] },
        },
    );
}

1;
