package Crypt::Skip32::Base64URLSafe;
use strict;
use warnings;
use MIME::Base64::URLSafe;
our $VERSION = '0.32';
use base 'Crypt::Skip32';

sub encrypt_number_b64_urlsafe {
    my ( $self, $number ) = @_;
    my $plaintext  = pack( 'N', $number );
    my $ciphertext = $self->encrypt($plaintext);
    my $b64        = urlsafe_b64encode($ciphertext);
    return $b64;
}

sub decrypt_number_b64_urlsafe {
    my ( $self, $b64 ) = @_;
    my $ciphertext = urlsafe_b64decode($b64);
    my $plaintext  = $self->decrypt($ciphertext);
    my $number     = unpack( 'N', $plaintext );
    return $number;
}

1;

__END__

=head1 NAME

Crypt::Skip32::Base64URLSafe - Create URL-safe encodings of 32-bit values

=head1 SYNOPSIS

  use Crypt::Skip32::Base64URLSafe;
  my $key    = pack( 'H20', "112233445566778899AA" ); # Always 10 bytes!
  my $cipher = Crypt::Skip32::Base64URLSafe->new($key);
  my $b64    = $cipher->encrypt_number_b64_urlsafe(3493209676); # baJxAA
  my $number = $cipher->decrypt_number_b64_urlsafe('baJxAA'); # 493209676

=head1 DESCRIPTION

This module melds together L<Crypt::Skip32> and L<MIME::Base64::URLSafe>.

L<Crypt::Skip32> is a 80-bit key, 32-bit block cipher based on Skipjack.
One example where Crypt::Skip32 has been useful: You have numeric database
record ids which increment sequentially. You would like to use them in
URLs, but you don't want to make it obvious how many X's you have in 
the database by putting the ids directly in the URLs.

L<MIME::Base64::URLSafe> creates a URL-safe Base64 version of a string.

Putting the two together lets you have numeric database records ids
which you can use safely in URLs without letting users see how many
records you have or letting them jump forward or backwards between
records.

You should pick a different key to the one in the synopsis.
It should be 10 bytes.

=head1 AUTHOR

Leon Brocard <acme@astray.com>.
