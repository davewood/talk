package Talk::Form::Slide;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Widget::Theme::Bootstrap';

has '+item_class' => (default => 'Slide');
has_field 'title' => (
    type     => 'Text',
    required => 1
);
has_field 'content' => (
    type     => 'TextArea',
    required => 1
);
has_field 'submit' => (type => 'Submit');
1;
