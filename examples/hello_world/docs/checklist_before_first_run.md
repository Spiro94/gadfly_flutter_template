# Checklist before first run

This is the checklist to go through before running your application for the
first time.

## Step 0: Make sure your computer's setup is ready for development

Read `docs/development_setup.md`.

## Step 1: Make a new project in supabase

Go to [Supabase.com](https://supabase.com) and create a new project.

## Step 2: Update your email auth provider settings

Find your auth provider settings and do the following:

![update_email_auth_provider](images/checklist_before_first_run/update_email_auth_provider.png?raw=true)

## Step 3: Link your Supabase project

Sign in to Supabase:

```sh
supabase login
```

Find your project's ref in Supabase then link it:

```sh
supabase link --project-ref XXX
```

## Step 4: Add Amplitude script to your web/index.html file

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

## Step 5: Update your app's configuration file

Go to `app/lib/main/configurations.dart` and replace all the `CHANGE ME` texts with your credentials.

For the **development** builds use these:

- Supabase: run `supabase start` in a terminal, then find the `API URL` and
     the `anon key` in the printout.
- Amplitude: N/A
- Sentry: N/A

For the **production** build use these:

- ![Supabase credentials](images/checklist_before_first_run/supabase_credentials.png?raw=true)
- ![Amplitude credentials](images/checklist_before_first_run/amplitude_credentials.png?raw=true)
- ![Sentry DSN](images/checklist_before_first_run/sentry_dsn.png?raw=true)
- ![Sentry environment](images/checklist_before_first_run/sentry_environment.png?raw=true)
