# Development Setup

## Flutter version management

Install [FVM](https://fvm.app/)

```sh
brew tap leoafarias/fvm

brew install fvm

fvm install 3.13.3
```

## Redux remote devtools

Get [pyenv](https://github.com/pyenv/pyenv), then set your shell to use python 2.7.28 to install redux's [remotedev-server](https://www.npmjs.com/package/remotedev-server).

```sh
brew install pyenv
```

```sh
pyenv init
# make sure to follow the instructions
```

```sh
pyenv install 2.7.18
```

```sh
pyenv shell 2.7.18

npm install -g remotedev-server
```

## Mkdocs

Install mkdocs.

```sh
brew install mkdocs
```

Install mkdocs theme.

```sh
pip install mkdocs-material
```

## Supabase

Get Supabase:

```sh
brew install supabase/tap/supabase
```

Sign in to Supabase:

```sh
supabase login
```

Create a project in Supabase then link it:

```sh
supabase link --project-ref XXX
```

Finally, go to your Supabase project in the browser and do the following:

- Click on the Authentication tab
- Click on Providers
- Click on Email
- Click on 'Confirm Email' to set it to off
- Change min password length from 6 to 8
- Click save

## PostgresQL

Get `psql`

```sh
brew install postgresql@15
```

Then add the following to your `~/.zshrc` file:

```sh
# postgres
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
```

## PgAdmin

Get `PgAdmin`

```sh
brew install --cask pgadmin4
```

## Amplitude (for Web)

Add the following script to `web/index.html` file.

```html
<script type="text/javascript" defer>
  (function (e, t) {
    var n = e.amplitude || { _q: [], _iq: {} };
    var r = t.createElement('script');
    r.type = 'text/javascript';
    r.integrity =
      'sha384-UcvEbHmT0LE2ZB30Y3FmY3Nfw6puAKXz/LpCFuoywywYikMOr/519Uu1yNq2nL9w';
    r.crossOrigin = 'anonymous';
    r.async = true;
    r.src = 'https://cdn.amplitude.com/libs/amplitude-8.12.0-min.gz.js';
    r.onload = function () {
      if (!e.amplitude.runQueuedFunctions) {
        console.log('[Amplitude] Error: could not load SDK');
      }
    };
    var s = t.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(r, s);
    function i(e, t) {
      e.prototype[t] = function () {
        this._q.push([t].concat(Array.prototype.slice.call(arguments, 0)));
        return this;
      };
    }
    var o = function () {
      this._q = [];
      return this;
    };
    var a = [
      'add',
      'append',
      'clearAll',
      'prepend',
      'set',
      'setOnce',
      'unset',
      'preInsert',
      'postInsert',
      'remove',
    ];
    for (var c = 0; c < a.length; c++) {
      i(o, a[c]);
    }
    n.Identify = o;
    var u = function () {
      this._q = [];
      return this;
    };
    var l = [
      'setProductId',
      'setQuantity',
      'setPrice',
      'setRevenueType',
      'setEventProperties',
    ];
    for (var p = 0; p < l.length; p++) {
      i(u, l[p]);
    }
    n.Revenue = u;
    var d = [
      'init',
      'logEvent',
      'logRevenue',
      'setUserId',
      'setUserProperties',
      'setOptOut',
      'setVersionName',
      'setDomain',
      'setDeviceId',
      'enableTracking',
      'setGlobalUserProperties',
      'identify',
      'clearUserProperties',
      'setGroup',
      'logRevenueV2',
      'regenerateDeviceId',
      'groupIdentify',
      'onInit',
      'logEventWithTimestamp',
      'logEventWithGroups',
      'setSessionId',
      'resetSessionId',
      'getDeviceId',
      'getUserId',
      'setMinTimeBetweenSessionsMillis',
      'setEventUploadThreshold',
      'setUseDynamicConfig',
      'setServerZone',
      'setServerUrl',
      'sendEvents',
      'setLibrary',
      'setTransport',
    ];
    function v(e) {
      function t(t) {
        e[t] = function () {
          e._q.push([t].concat(Array.prototype.slice.call(arguments, 0)));
        };
      }
      for (var n = 0; n < d.length; n++) {
        t(d[n]);
      }
    }
    v(n);
    n.getInstance = function (e) {
      e = (!e || e.length === 0 ? '$default_instance' : e).toLowerCase();
      if (!Object.prototype.hasOwnProperty.call(n._iq, e)) {
        n._iq[e] = { _q: [] };
        v(n._iq[e]);
      }
      return n._iq[e];
    };
    e.amplitude = n;
  })(window, document);
</script>
```
