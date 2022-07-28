use facility;
use strict;
use warnings;

my $value = 1;

fusion::stick($value, "i", 0, 0, 0, 0);

fusion::clock(500);

fusion::stick(! $value, "i", 0, 0, 0, 0);

#fusion::clock(4);
#fusion::stick($value, "i", 0, 0, 0, 0);

fusion::clock(500);

fusion::stick($value, "i", 0, 0, 0, 0);

fusion::clock(50);

fusion::pass("");
fusion::clock(0);
