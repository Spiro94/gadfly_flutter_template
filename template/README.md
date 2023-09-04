# gadfly_flutter_template

## Development Setup

### Flutter version management

Install [FVM](https://fvm.app/)

```sh
brew tap leoafarias/fvm

brew install fvm

fvm install 3.12.0
```

### Redux remote devtools

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

### Web and Amplitude

Add the following script to `web/index.html` file.

```html
<script type="text/javascript" defer>
   (function(e,t){var n=e.amplitude||{_q:[],_iq:{}};var r=t.createElement("script")
    ;r.type="text/javascript"
    ;r.integrity="sha384-UcvEbHmT0LE2ZB30Y3FmY3Nfw6puAKXz/LpCFuoywywYikMOr/519Uu1yNq2nL9w"
    ;r.crossOrigin="anonymous";r.async=true
    ;r.src="https://cdn.amplitude.com/libs/amplitude-8.12.0-min.gz.js"
    ;r.onload=function(){if(!e.amplitude.runQueuedFunctions){
    console.log("[Amplitude] Error: could not load SDK")}}
    ;var s=t.getElementsByTagName("script")[0];s.parentNode.insertBefore(r,s)
    ;function i(e,t){e.prototype[t]=function(){
    this._q.push([t].concat(Array.prototype.slice.call(arguments,0)));return this}}
    var o=function(){this._q=[];return this}
    ;var a=["add","append","clearAll","prepend","set","setOnce","unset","preInsert","postInsert","remove"]
    ;for(var c=0;c<a.length;c++){i(o,a[c])}n.Identify=o;var u=function(){this._q=[]
    ;return this}
    ;var l=["setProductId","setQuantity","setPrice","setRevenueType","setEventProperties"]
    ;for(var p=0;p<l.length;p++){i(u,l[p])}n.Revenue=u
    ;var d=["init","logEvent","logRevenue","setUserId","setUserProperties","setOptOut","setVersionName","setDomain","setDeviceId","enableTracking","setGlobalUserProperties","identify","clearUserProperties","setGroup","logRevenueV2","regenerateDeviceId","groupIdentify","onInit","logEventWithTimestamp","logEventWithGroups","setSessionId","resetSessionId","getDeviceId","getUserId","setMinTimeBetweenSessionsMillis","setEventUploadThreshold","setUseDynamicConfig","setServerZone","setServerUrl","sendEvents","setLibrary","setTransport"]
    ;function v(e){function t(t){e[t]=function(){
    e._q.push([t].concat(Array.prototype.slice.call(arguments,0)))}}
    for(var n=0;n<d.length;n++){t(d[n])}}v(n);n.getInstance=function(e){
    e=(!e||e.length===0?"$default_instance":e).toLowerCase()
    ;if(!Object.prototype.hasOwnProperty.call(n._iq,e)){n._iq[e]={_q:[]};v(n._iq[e])
    }return n._iq[e]};e.amplitude=n})(window,document);
</script>
```

## Development

### Run

Open the `Run and Debug` tab in VSCode and run the `development` option.

### Run and Send Events

This will send events to Amplitude and Sentry.

Open the `Run and Debug` tab in VSCode and run the `development & send events` option.

### Run with redux devtools

1. Start the redux remote devtools server

```sh
make redux_devtools_server
```

2. Then go to a browser and open `localhost:8001`. Note: it is important that this is open before you tun the application.

3. Open the `Run and Debug` tab in VSCode and run the `development w/ devtools` option.

### Update build_runner files

```sh
make runner_build
```

or

```sh
make runner_watch
```

### Update localization files

```sh
make slang_build
```

or

```sh
make slang_watch
```

### Update flutter dependences

```sh
make flutter_get
```

### Clean flutter build

```sh
make flutter_clean
```

## Testing

### Check coverage

```sh
make coverage_check
```

### Screenshots

```sh
make screenshots_delete
```

```sh
make screenshots_update
```
