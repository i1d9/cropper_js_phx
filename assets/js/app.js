// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
import Cropper from 'cropperjs';

// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"




let Hooks = {}



Hooks.OverrideImage = {

    mounted() {

        const image = document.getElementById('image');
        const image_input = document.getElementById('image_file_input');
        const save_button = document.getElementById('save_image');

        var cropper = '';

        image_input.addEventListener("change", (e) => {
            e.preventDefault()

            image.src = URL.createObjectURL(e.target.files[0]);
            cropper = new Cropper(image, {
                dragMode: 'move',
                aspectRatio: 1,
                autoCropArea: 0.75,
                restore: true,
                guides: true,
                center: true,
                highlight: true,
                cropBoxMovable: true

            });

            save_button.setAttribute("style", "display: block;");

        });


        save_button.addEventListener("click", (e) => {

            let canvas = cropper.getCroppedCanvas();

            if (canvas != null) {
                
                
                canvas.toBlob((blob) => {
                    //Saves to socket will upload if autoupload is set to true
                    this.upload("avatar", [blob]);
                });
            }

        });


    }
}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

