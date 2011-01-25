package Plack::Middleware::MobileAgentLite;

use strict;
use warnings;
use parent 'Plack::Middleware';
our $VERSION = '0.06';

my $ma = HTTP::MobileAgentLite->new();;

sub call {
    my ( $self, $env ) = @_;

    $env->{'psgix.mobile_agent_lite'} = $ma->detect($env);

    $self->app->($env);
}

package 
    HTTP::MobileAgentLite;

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
my $iPhoneRE          = '^Mozilla/5\.0 \(iPhone; U; CPU ';
my $AndroidRE         = '^Mozilla/5\.0 \(Linux; U; Android \d\.\d(?:-update1)?;';
my $BotRE             = qr/Google|Yahoo|http|craw|lwp/;
our $MobileAgentRE =
qr/(?:($DoCoMoRE)|($JPhoneRE|$VodafoneRE|$VodafoneMotRE|$SoftBankRE|$SoftBankCrawlerRE)|($EZwebRE|$SAMsung)|($AirHRE)|($iPhoneRE)|($AndroidRE))/;
# http://www.nttdocomo.co.jp/binary/pdf/service/imode/make/content/spec/imode_spec.pdf
# http://cpansearch.perl.org/src/KURIHARA/HTTP-MobileAgent-0.29/lib/HTTP/MobileAgent/DoCoMo.pm
our $GPSModelsRe = qr/L01B|N05B|N04B|N02B|N01B|P06B|P04B|P02B|P01B|F09B|F07B|F06B|F04B|F03B|F02B|F01B|SH08B|SH07B|SH04B|SH03B|SH02B|SH01B|SH08A|SH07A|SH06A|SH05A|SH04A|SH03A|SH02A|SH01A|N09A|N08A|N06A|N02A|N01A|P09A|P08A|P07A|P02A|P01A|F10A|F09A|F06A|F05A|F03A|F01A|N906iL|N906i|F906i|N906imyu|SH906i|SO906i|P906i|F884iES|F884i|F801i|F905iBiz|SO905iCS|N905iTV|N905iBiz|N905imyu|SO905i|F905i|P905i|N905i|D905i|SH905i|P904i|D904i|F904i|N904i|SH904i|F883iESS|F883iES|F903iBSC|SO903i|F903i|D903i|N903i|P903i(?!TV|X)|SH903i|SA800i|SA702i|SA700iS|F505iGPS|F661i/;

sub _default_res_data {

    return {
        is_docomo        => 0,
        is_ezweb         => 0,
        is_vodafone      => 0,
        is_softbank      => 0,
        is_airh          => 0,
        is_iphone        => 0,
        is_android       => 0,
        is_non_mobile    => 0,
        is_bot           => 0,
        is_mobile        => 0,
        is_smartphone    => 0,
        is_gps           => 0,
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
            $res->{is_mobile}        = 1;
            $res->{is_docomo}        = 1;
            $res->{carrier}          = "I";
            $res->{carrier_longname} = "DoCoMo";
            $res->{encoding}         = "x-utf8-docomo";
            $res->{content_type}     = "application/xhtml+xml";
            $res->{user_id}          = $env->{HTTP_X_DCMGUID};
            $res->{is_gps}           = 1 if $ua =~ $GPSModelsRe;
        }
        elsif ($2) {
            $res->{is_mobile}        = 1;
            $res->{is_mobile}        = 1;
            $res->{is_vodafone}      = 1;
            $res->{is_softbank}      = 1;
            $res->{is_gps}           = 1;
            $res->{carrier}          = "V";
            $res->{carrier_longname} = "Vodafone";
            $res->{encoding}         = "x-utf8-vodafone";
            $res->{user_id}          = $env->{HTTP_X_JPHONE_UID};
        }
        elsif ($3) {
            $res->{is_mobile}        = 1;
            $res->{is_ezweb}         = 1;
            $res->{carrier}          = "E";
            $res->{carrier_longname} = "EZweb";
            $res->{encoding}         = "x-sjis-ezweb-auto";
            $res->{content_type}     = "text/html;charset=shift_jis";
            $res->{user_id}          = $env->{HTTP_X_UP_SUBNO};
            
            my @specs = split //, $env->{HTTP_X_UP_DEVCAP_MULTIMEDIA} || '';
            $res->{is_gps}  =  1 if defined $specs[ 1 ] && $specs[ 1 ] =~ /^[23]$/;
        }
        elsif ($4) {
            $res->{is_mobile}        = 1;
            $res->{is_airh}          = 1;
            $res->{carrier}          = "H";
            $res->{carrier_longname} = "AirHPhone";
            $res->{content_type}     = "text/html;charset=shift_jis";
            $res->{encoding}         = "x-sjis-docomo";
        }
        elsif ($5) {
            $res->{is_iphone}        = 1;
            $res->{is_smartphone}    = 1;
            $res->{carrier}          = "S";
            $res->{carrier_longname} = "iPhone";
        }
        elsif ($6) {
            $res->{is_android}       = 1;
            $res->{is_smartphone}    = 1;
            $res->{carrier}          = "A";
            $res->{carrier_longname} = "Android";
        }
    }
    else {
        $res->{is_non_mobile} = 1;
    }

    $res->{is_bot} = 1 if $ua =~ $BotRE;
    $res;
}

package 
    Plack::Middleware::MobileAgentLite;

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
