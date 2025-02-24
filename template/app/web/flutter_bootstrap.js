{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    console.log('loadding flutter app...');

    var loading = document.querySelector('#loading');

    // Completely reload the page if Flutter tries to only restart itself.
    if (loading === null) {
      window.location.reload();
      return;
    }

    loading.classList.add('main_done');
    const appRunner = await engineInitializer.initializeEngine();

    loading.classList.add('init_done');
    await appRunner.runApp();


    loading.remove();
  },
  serviceWorkerSettings: {
      serviceWorkerVersion: {{flutter_service_worker_version}}
  }
});
