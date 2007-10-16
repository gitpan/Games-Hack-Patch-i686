#########################

use Test::More tests => 6;

sub BEGIN {
use_ok('Games::Hack::Patch::i686');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

$bin=GetNOP(5,6, 'nop');
is($bin, "\x90", "NOP");

$bin=GetNOP(5,10, 'mov eax,$1');
is($bin, "\xeb\x03", "Simply short jump");

{ TODO: {
	local $TODO="floating point ops not done yet";

	$bin=GetNOP(5,10, 'fstp +20(%ebp)');
	is($bin, "", "Floating point op");
} }

{ TODO: {
	local $TODO="SIMD ops not done yet";

	$bin=GetNOP(5,10, '');
	is($bin, "", "SIMD op");
} }

ok("finished");

