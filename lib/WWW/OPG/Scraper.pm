package WWW::OPG::Scraper;
# ABSTRACT: Perl interface to OPG's power generation statistics (web scraper)

use strict;
use warnings;
use Carp ();

use LWP::UserAgent;
use DateTime;

=head1 SYNOPSIS

  use WWW::OPG::Scraper;

  my $opg = WWW::OPG::Scraper->new();
  eval {
    $opg->poll();
  };
  print "Currently generating ", $opg->power, "MW of electricity\n";

=head1 DESCRIPTION

This module was formerly the main interface provided in L<WWW::OPG>. It
provides a Perl interface to information published on Ontario Power
Generation's web site at L<http://www.opg.com> by scraping the main page.

=head1 METHODS

=head2 new

  WWW::OPG::Scraper->new( \%params )

Implements the interface as specified in C<WWW::OPG>

=cut

sub new {
  my ($class, $params) = @_;

  Carp::croak('You must call this as a class method') if ref($class);

  my $self = {
  };

  if (exists $params->{useragent}) {
    $self->{useragent} = $params->{useragent};
  }
  else {
    my $ua = LWP::UserAgent->new;
    $ua->agent($class . '/' . $class->VERSION . ' ' . $ua->_agent);
    $self->{useragent} = $ua;
  }

  bless($self, $class);
  return $self;
}

=head2 poll

  $opg->poll()

Implements the interface as specified in C<WWW::OPG>

=cut

sub poll {
  my ($self) = @_;

  Carp::croak('You must call this method as an object') unless ref($self);

  my $ua = $self->{useragent};
  my $r = $ua->get('http://www.opg.com/');

  Carp::croak('Error reading response: ' . $r->status_line)
    unless $r->is_success;

  if ($r->content =~ m{
      ([0-9]+),?([0-9]+)</span><span\ class='wht'>\ MW</span>
    }x)
  {
    $self->{power} = $1 . $2;

    if ($r->content =~ m{
        Last\ updated:\ (\d+)/(\d+)/(\d+)\ (\d+):(\d+):(\d+)\ (AM|PM)  
      }x)
    {
      my $hour = $4;
      # 12:00 noon and midnight are a special case
      if ($hour == 12) {
        # 12am is midnight
        if ($7 eq 'AM') {
          $hour = 0;
        }
      }
      elsif ($7 eq 'PM') {
        $hour += 12;
      }

      my $dt = DateTime->new(
        month     => $1,
        day       => $2,
        year      => $3,
        hour      => $hour, # derived from $4
        minute    => $5,
        second    => $6,
        time_zone => 'America/Toronto',
      );

      if (!exists $self->{updated} || $self->{updated} != $dt)
      {
        $self->{updated} = $dt;
        return 1;
      }
      return 0;
    }
  }

  die 'Error parsing response, perhaps the format has changed?';
  return;
}

=head2 power

  $opg->power()

Implements the interface as specified in C<WWW::OPG>

=cut

sub power {
  my ($self) = @_;

  Carp::croak('You must call this method as an object') unless ref($self);

  return unless exists $self->{power};
  return $self->{power};
}

=head2 last_updated

  $opg->last_updated()

Implements the interface as specified in C<WWW::OPG>

=cut

sub last_updated {
  my ($self) = @_;

  Carp::croak('You must call this method as an object') unless ref($self);

  return unless exists $self->{updated};
  return $self->{updated};
}

=head1 SEE ALSO

L<WWW::OPG>

=cut

1;
