#!/usr/bin/perl
# vim: set sw=2 expandtab : #

$VERSION=0.1;

sub GetNOP
{
  my($adr_start, $adr_end, @disass)=@_;
  my($binary, $diff);

  $binary="";

  if ($disass[0] =~ m#fstp#)
  {

  }

# short jump
  if (($diff=$adr_end-$adr_start) >= 2)
  {
# The opcode needs two bytes; these are already consumed.
    $binary .= "\xeb" . pack("C", $diff-2);
    $adr_end=$adr_start;
  }

# NOP
  $binary .= "\x90" x $diff
    if ($diff=$adr_end-$adr_start) >= 1;

  return $binary;
}


__END__

=head1 NAME

Games::Hack::Patch::i686 - How to patch code sequences on i686

=head1 SYNOPSIS

  $bytes=GetNOP( $adr_start, $adr_end, @disass );

=head1 DESCRIPTION

Not useful in itself; is used by C<Games::Hack::Live>, and will possibly be 
used by C<Games::Hack::Offline>.

Addresses given to this library are always in integer/decimal, so that the 
script can simply add and subtract. (C<gdb> returns hex values.)

=head2 GetNOP

Given a start and an end address, and the disassembled instructions 
(although normally only one) in the range (via C<gdb>), return a binary 
string that, when written at the start address, causes this part of the 
program to be ignored.

=over

=item Memory moves from register

The easiest way is simply returning the NOP opcode (0x90 on x86), as many times 
as needed.

A bit better, because it's shorter, is to return a C<short jump>, with the 
correct offset.

=item Floating point operations

Unfortunately there are some instructions with side effects; eg. the 
coprocessor instructions are typically issued with the suffix I<pop stack>, 
which causes this instruction to change the internal state.

Simply jumping over such sequences leaves the old values on the coprocessor 
stack and can cause irregular behaviour, aborts, core dumps, and other crashes.

So some care must be taken for them.

=back

=head1 BUGS/CAVEATS/TODO/IDEAS/WISHLIST

=over

=item Some QA

A look from someone that knows all possible instructions, along with their 
side-effects, would be appreciated.

=item Hardware support

Modules for other CPUs would be nice.

=back

Patches are welcome.


=head1 AUTHOR

Ph. Marek <pmarek@cpan.org>


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Ph. Marek;
licensed under the GPLv3.

=cut

