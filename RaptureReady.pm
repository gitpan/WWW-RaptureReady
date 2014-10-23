package WWW::RaptureReady;

#
# $Id: RaptureReady.pm,v 1.1 2005/01/22 05:58:48 blair Exp $
#

use 5.006001;
use strict;
use warnings;
use Carp            ();
use LWP::UserAgent  ();

=head1 NAME

WWW::RaptureReady - Interface to Rapture Ready's Rapture Index

=head1 VERSION

This document describes WWW::RaptureReady version 0.1.

=cut

our $VERSION = '0.1';

=head1 SYNOPSIS

  use WWW::RaptureReady;
  my $rr = WWW::RaptureReady->new;
  print "URL:           ", $rr->url,     "\n",
        "Current Index: ", $rr->index,   "\n",
        "Index Change:  ", $rr->change,  "\n",
        "Last Updated:  ", $rr->updated, "\n";

=head1 DESCRIPTION

This module provides an interface to the I<Rapture Ready> 
I<Rapture Index>.  I<Rapture Ready>'s description of the index:

  The Rapture Index has two functions: one is to factor together a
  number of related end time components into a cohesive indicator,
  and the other is to standardize those components to eliminate the
  wide variance that currently exists with prophecy reporting.

  The Rapture Index is by no means meant to predict the rapture,
  however, the index is designed to measure the type of activity
  that could act as a precursor to the rapture.

  You could say the Rapture index is a Dow Jones Industrial Average
  of end time activity, but I think it would be better if you viewed
  it as prophetic speedometer. The higher the number, the faster
  we're moving towards the occurrence of pre-tribulation rapture.


The rapture index is the "prophetic speedometer
of end-time activity".

=head1 INTERFACE

=head2 new()

Creates and returns a new WWW::RaptureReady object.

  my $rr = WWW::RaptureReady->new

=cut

sub new {
  my ($class, @args) = @_; 
  my $self = bless {}, ref($class) || $class; 
  # Default location of the Rapture Index
  $self->{url}  = "http://www.raptureready.com/rap2.html";
  $self->{ua}   = LWP::UserAgent->new;
  $self->{ua}->agent('WWW::RaptureReady/' . $VERSION);
  $self->{ua}->from('blair@devclue.com'); 
  return $self; 
}

=head2 url()

Returns the configured URL for retrieving the I<Rapture Index>.

  my $url = $rr->url

=head2 url($url)

Sets the URL to be used for retrieving the I<Rapture Index>.

  $rr->url("http://example.com/rapture.html")

=cut

sub url {
  my ($self, $url) = @_;
  if (defined $url) {
    if ($url =~ m%^(?:file|https?):%) {
      $self->{url} = $url;
    } else {
      $self->{url} = 'file:' . $url;
    }
  }
  return $self->{url};
}

=head2 fetch()

Fetches the I<Rapture Index> HTML from the configured URL.

  $rr->fetch

=cut

sub fetch {
  my $self = shift;
  my $rv  = undef;
  my $res = $self->{ua}->get($self->{url});
  if ($res->is_success) {
    # Fetch and cache the Rapture Index HTML
    $self->{content} = $res->content;
    $rv = 1;
  } else {
    Carp::carp($res->status_line);    
  }
  return $rv;
}

=head2 index()

Returns the current index level.  Calls I<fetch()> if index not already
retrieved.

  my $index = $rr->index

=cut

sub index {
  my $self = shift;
  my $rv = undef;
  if ($self->{content} or $self->fetch) {
    # TODO Make this less fragile
    if ($self->{content} =~ />Rapture Index\s+(\d+)\s*?/) {
      $rv = $1;
    }
  }
  return $rv;
}

=head2 change()

Returns the change in the index.  Calls I<fetch()> if index not already
retrieved.

  my $change = $rr->change

=cut

sub change {
  my $self = shift;
  my $rv = undef;
  if ($self->{content} or $self->fetch) {
    # TODO Make this less fragile
    if ($self->{content} =~ />Net Change\s+([+\-]\d+)\s*?/) {
      $rv = $1;
    }
  }
  return $rv;
}

=head2 updated()

Returns when the index was last updated.  Calls I<fetch()> if index not
already retrieved.

  my $updated = $rr->updated

=cut

sub updated {
  my $self = shift;
  my $rv = undef;
  if ($self->{content} or $self->fetch) {
    # TODO Make this less fragile
    if ($self->{content} =~ />Updated (\w+\s+\d+,\s+\d+)/) {
      $rv = $1;
    }
  }
  return $rv;
}

=head1 SEE ALSO

L<Perl>, L<LWP::UserAgent>, L<http://www.raptureready.com/rap2.html>

=head1 AUTHOR

blair christensen., E<lt>blair@devclue.comE<gt>

<http://devclue.com/blog/code/WWW::RaptureReady/>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by blair christensen.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 DISCLAIMER OF WARRANTY                                                                                               

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO
WARRANTY FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE
LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS
AND/OR OTHER PARTIES PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE,
YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA
BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES
OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY
OF SUCH DAMAGES.

=cut

1;
