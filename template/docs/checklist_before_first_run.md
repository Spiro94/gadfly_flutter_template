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

Go to `app/lib/main/configurations.dart` and replace all the `CHANGE ME` texts
with your credentials.

For the **development** builds:

- They should be good to go for web and iOS
- For android, replace instances of localhost with your machine's ip address.

For the **production** build use these:

- ![Supabase credentials](images/checklist_before_first_run/supabase_credentials.png?raw=true)
- ![Amplitude credentials](images/checklist_before_first_run/amplitude_credentials.png?raw=true)
- ![Sentry DSN](images/checklist_before_first_run/sentry_dsn.png?raw=true)
- ![Sentry environment](images/checklist_before_first_run/sentry_environment.png?raw=true)

## Step 6: Support recording audio

We make use of [record](https://github.com/llfbandit/record/tree/master/record),
and we need to update android and iOS accordingly.

**Android**

In the following files:

- `app/android/app/src/debug/AndroidManifest.xml`
- `app/android/app/src/profile/AndroidManifest.xml`

Add this snippet:

```xml
<!-- Record Audio -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

**iOS**

```xml
<!-- ... other tags -->
<plist>
<dict>
  <!-- ... other tags -->

  <!-- Record audio -->
  <key>NSMicrophoneUsageDescription</key>
  <!-- CHANGE ME -->
  <string>Some message to describe why you need this permission</string>

</dict>
</plist>
```

## Step 7: Set up Deep Links

Update the redirect links in `supabase/config.toml` under the `[auth]` section:

```toml
additional_redirect_urls = [
  # For Web (catch all)
  "https://127.0.0.1:3000", 
  # For Mobile (needs to be individually specified)
  "com.example.myapp.deep://deeplink-callback",
  "com.example.myapp.deep://deeplink-callback/#/deep/resetPassword"
]
```

Update `app/ios/Runner/Info.plist` to include the following:

```xml
<!-- ... other tags -->
<plist>
<dict>
  <!-- ... other tags -->

  <!-- Add this array for Deep Links -->
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeRole</key>
      <string>Editor</string>
      <key>CFBundleURLSchemes</key>
      <array>
      <!-- CHANGE ME before going to production -->
        <string>com.example.myapp.deep</string>
      </array>
    </dict>
  </array>
  <!-- ... other tags -->
</dict>
</plist>
```

Update `app/android/app/src/main/AndroidManifest.xml` to include the following:

```xml
<manifest ...>
  <!-- ... other tags -->
  <application ...>
    <activity ...>
      <!-- ... other tags -->

      <!-- Add this intent-filter for Deep Links -->
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <!-- Accepts URIs that begin with YOUR_SCHEME://YOUR_HOST -->
        <!-- CHANGE ME: change scheme before going to production -->
        <data
          android:scheme="com.example.myapp.deep"
          android:host="deeplink-callback" />
      </intent-filter>

    </activity>
  </application>
</manifest>
```

Finally, do a search and replace for `com.example.myapp.deep` and replace it
with the name of your project. For example `com.example.hello-world.deep` (in
kebab-case).

![deep_link1](images/checklist_before_first_run/deep_link1.png?raw=true)

## Step 8: Add storage to Supabase

Run this command:

```sh
supabase migration new storage_recordings_policy
```

and paste in the following:

```sql
create policy "Users own their folder c5wwbm_0"
on "storage"."objects"
as permissive
for select
to authenticated
using (((bucket_id = 'recordings'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


create policy "Users own their folder c5wwbm_1"
on "storage"."objects"
as permissive
for insert
to authenticated
with check (((bucket_id = 'recordings'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


create policy "Users own their folder c5wwbm_2"
on "storage"."objects"
as permissive
for update
to authenticated
using (((bucket_id = 'recordings'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


create policy "Users own their folder c5wwbm_3"
on "storage"."objects"
as permissive
for delete
to authenticated
using (((bucket_id = 'recordings'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));
```

Run this command:

```sh
supabase migration new storage_realtime
```

and paste in the following:

```sql
alter publication supabase_realtime add table storage.objects;
```

Update the `supabase/seed.sql` file to contain the following:

```sql
INSERT INTO storage.buckets(id, name)
VALUES 
    ('recordings', 'recordings')
```
