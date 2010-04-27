package Plack::Middleware::MobileAgentLite;

use strict;
use warnings;

use parent 'Plack::Middleware';
our $VERSION = '0.03';

my $ma = HTTP::MobileAgentLite->new();;

sub call {
    my ( $self, $env ) = @_;

    $env->{'psgix.mobile_agent_lite'} = $ma->detect($env);

    $self->app->($env);
}

package HTTP::MobileAgentLite;

use strict;
use warnings;


my $DoCoMoRE          = '^DoCoMo/\d\.\d[ /]';
my $JPhoneRE          = '^(?i:J-PHONE/\d\.\d)';
my $VodafoneRE        = '^Vodafone/\d\.\d';
my $VodafoneMotRE     = '^MOT-';
my $SoftBankRE        = '^SoftBank/\d\.\d';
my $SoftBankCrawlerRE = '^Nokia[^/]+/\d\.\d';
my $EZwebRE           = '^(?:KDDI-[A-Z]+\d+[A-Z]? )?UP\.Browser\/';
my $SAMsung           = '^SAMSUNG-';
my $AirHRE            = '^Mozilla/3\.0\((?:WILLCOM|DDIPOCKET)\;';
my $BotRE             = qr/Google|Yahoo|http|craw|lwp/;
our $MobileAgentRE =
qr/(?:($DoCoMoRE)|($JPhoneRE|$VodafoneRE|$VodafoneMotRE|$SoftBankRE|$SoftBankCrawlerRE)|($EZwebRE|$SAMsung)|($AirHRE))/;

sub _default_res_data {

    return {
        is_docomo        => 0,
        is_ezweb         => 0,
        is_vodafone      => 0,
        is_softbank      => 0,
        is_airh          => 0,
        is_non_mobile    => 0,
        is_bot           => 0,
        is_mobile        => 0,
        encoding         => 'utf-8',
        content_type     => 'text/html;charset=utf-8',
        carrier          => "",
        carrier_longname => "",
        user_id          => undef,
    };
}

sub new {  bless {}, $_[0] }

sub detect {
    my ( $self, $env ) = @_;
    my $res = _default_res_data();
    my $ua  = $env->{HTTP_USER_AGENT} || "unknown";

    if ( $ua =~ $MobileAgentRE ) {
        if ($1) {
            $res->{is_docomo}        = 1;
            $res->{carrier}          = "I";
            $res->{carrier_longname} = "DoCoMo";
            $res->{encoding}         = "x-utf8-docomo";
            $res->{content_type}     = "application/xhtml+xml";
            $res->{user_id}          = $env->{HTTP_X_DCMGUID};
        }
        elsif ($2) {
            $res->{is_vodafone}      = 1;
            $res->{is_softbank}      = 1;
            $res->{carrier}          = "V";
            $res->{carrier_longname} = "Vodafone";
            $res->{encoding}         = "x-utf8-vodafone";
            $res->{user_id}          = $env->{HTTP_X_JPHONE_UID};
        }
        elsif ($3) {
            $res->{is_ezweb}         = 1;
            $res->{carrier}          = "E";
            $res->{carrier_longname} = "EZweb";
            $res->{encoding}         = "x-sjis-ezweb-auto";
            $res->{content_type}     = "text/html;charset=shift_jis";
            $res->{user_id}          = $env->{HTTP_X_UP_SUBNO};
        }
        elsif ($4) {
            $res->{is_airh}          = 1;
            $res->{carrier}          = "H";
            $res->{carrier_longname} = "AirHPhone";
            $res->{content_type}     = "text/html;charset=shift_jis";
            $res->{encoding}         = "x-sjis-docomo";
        }
        $res->{is_mobile} = 1;
    }
    else {
        $res->{is_non_mobile} = 1;
    }

    $res->{is_bot} = 1 if $ua =~ $BotRE;
    $res;
}

package Plack::Middleware::MobileAgentLite;

1;
__END__

=head1 NAME

Plack::Middleware::MobileAgentLite -

=head1 SYNOPSIS

    builder {

        enable "Plack::Middleware::MobileAgentLite";
        $app->handler;
    };

=head1 DESCRIPTION

Plack::Middleware::MobileAgentLite is

=head1 AUTHOR

Tooru Midorikawa E<lt>tooru@omakase.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
