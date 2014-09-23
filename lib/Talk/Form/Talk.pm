package Talk::Form::Talk;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'Talk::Role::Form';

has '+item_class' => (default => 'Talk');
has_field 'title' => (
    type     => 'Text',
    required => 1
);
has_field 'submit' => (type => 'Submit');
1;
