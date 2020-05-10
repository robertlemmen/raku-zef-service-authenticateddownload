use Zef;
use Net::HTTP::GET;
use Net::HTTP::URL;

class Zef::Service::AuthenticatedDownload does Fetcher does Probeable does Messenger {
    has $.configured-hosts;

    method !config-for-host($hostname) {
        for @($!configured-hosts) -> $h {
            if $h<hostname> eq $hostname {
                return $h;
            }
        }
        return Nil;
    }

    method fetch-matcher($url) {
        return False if not $url.lc.starts-with('http://' | 'https://');

        return defined self!config-for-host(Net::HTTP::URL.new($url).host);
    }

    method probe {
        state $probe = True;
    }

    method fetch($url, IO() $save-as) {
        die "target download directory {$save-as.parent} does not exist and could not be created"
            unless $save-as.parent.d || mkdir($save-as.parent);

        my $host = Net::HTTP::URL.new($url).host;
        my $config = self!config-for-host($host);

        my %header;
        given $config<auth-type> {
            when 'opaque-token' {
                my $token = %*ENV{'ZEF_AUTH_OPAQUE_TOKEN'} // $config<token>;
                if ! defined $token {
                    my $msg = "No token available from config or ZEF_AUTH_OPAQUE_TOKEN, cannot authenticate against $host";
                    note $msg;
                    die $msg;
                }
                %header<Authorization> = "Bearer $token";
            }
            default {
                die "Unsupported auth-type '$_' in config of Zef::Service::AuthenticatedDownload";
            }
        }

        my $response = Net::HTTP::GET($url, :%header);
        if  $response.status-code == 200 {
            my $fh = $save-as.open(:w, :create, :bin);
            $fh.spurt($response.body);
            $fh.close;
            return $save-as.e;
        }
        return False;
    }
}
