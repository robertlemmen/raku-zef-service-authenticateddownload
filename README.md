# Zef::Service::AuthenticatedDownload

... Zef plugin to fetch modules from a repository that requires authentication,
like Shelve6

## Usage

First install the plugin via zef:

```
    zef install Zef::Service::AuthenticatedDownload
```

Or directly from the repository:

```
    zef install .
```

The zef README explains where you can find the zef config, where you can add the
plugin and configure it, which is best done before the other web fetchers to
avoid them trying to download and failing due to auth:

```
        {
            "short-name" : "authenticated-download",
            "module" : "Zef::Service::AuthenticatedDownload",
            "options" : { 
                "configured-hosts" : [
                    {
                        "hostname" : "localhost",
                        "auth-type" : "opaque-token",
                        "token" :  "supersecret"
                    }
                ]
            }
        },
```

This will make zef use this fetcher plugin for all retrievals from `localhost`
and use the configured method and credentials.

If you do not want the credentials in the config file, you can also use the
environment variable ZEF_AUTH_OPAQUE_TOKEN.

## ToDo

* More authentication types as required

## License

Zef::Service::AuthenticatedDownload is licensed under the [Artistic License 2.0](https://opensource.org/licenses/Artistic-2.0).

## Feedback and Contact

Please let me know what you think: Robert Lemmen <robertle@semistable.com>
