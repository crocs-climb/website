import '../css/main.css';
import { Elm } from '../elm/Main.elm';


// Start the Elm application.
Elm.Main.init({
  node: document.querySelector('main'),
});


// Start service workers
(async () => {
    if ("serviceWorker" in navigator) {
        try {
        const registration = await navigator.serviceWorker.register("./sw.js", {
            scope: "/",
        });
        if (registration.installing) {
            console.log("Service worker installing");
        } else if (registration.waiting) {
            console.log("Service worker installed");
        } else if (registration.active) {
            console.log("Service worker active");
        }
        } catch (error) {
        console.error(`Registration failed with ${error}`);
        }
    }
})();