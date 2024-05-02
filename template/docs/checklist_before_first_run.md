# Checklist before first run

This is the checklist to go through before running your application for the
first time.

## Step 0: Make sure your computer's setup is ready for development

Read `docs/development_setup.md`.

## Step 1: Update your app's configuration file

Go to `app/lib/main/configurations.dart` and replace all the `CHANGE ME` texts
with your credentials.

For the **development** builds:

- They should be good to go for web and iOS
- For android, replace instances of localhost with your machine's ip address.

For the **production** build use these:

- ![Amplitude credentials](images/checklist_before_first_run/amplitude_credentials.png?raw=true)
- ![Sentry DSN](images/checklist_before_first_run/sentry_dsn.png?raw=true)
- ![Sentry environment](images/checklist_before_first_run/sentry_environment.png?raw=true)

## Step 2: Update web directory

### Add Amplitude script to your web/index.html file

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

## Step 3: update min Android SDK version

In `app/android/app/build.gradle`, update the `minSdkVersion`:

```xml
defaultConfig {
<!-- ... -->

minSdkVersion 21

<!-- ... -->
}
```

## Step 4: Add your local ip address to `.envrc` file

Create a `.envrc` file and add the following, but replace the ip address with
your own:

```env
export MY_IP_ADDRESS="192.168.0.00"
```

**Note**: add `.envrc` to the top-level `.gitignore` file so it isn't checked in
to version control.

_Reminder, be sure to download the
[VSCode direnv extension](https://marketplace.visualstudio.com/items?itemName=mkhl.direnv)._
