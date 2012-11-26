use strict;
use warnings;

use Talk;

my $app = Talk->apply_default_middlewares(Talk->psgi_app);
$app;

