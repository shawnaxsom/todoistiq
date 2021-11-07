import Toybox.Application;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

class TodoistIQApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        makeRequest();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // set up the response callback function
    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            // Generate a new Menu with a drawable Title
            // var menu = new WatchUi.Menu2({:title=>new $.DrawableMenuTitle()});
            var menu = new WatchUi.Menu2({});

            // This comes from the Menu2Sample app provided by the Garmin Connect IQ SDK
            // Add menu items for demonstrating toggles, checkbox and icon menu items
            // menu.addItem(new WatchUi.MenuItem("Toggles", "sublabel", "toggle", null));
            // menu.addItem(new WatchUi.MenuItem("Checkboxes", null, "check", null));
            // menu.addItem(new WatchUi.MenuItem("Icons", null, "icon", null));
            // menu.addItem(new WatchUi.MenuItem("Custom", null, "custom", null));

            System.println("Request Successful");                   // print success
            for (var i = 0; i < data.size(); i++) {
                System.println(data[i]);                   // print success
                menu.addItem(new WatchUi.MenuItem(data[i]["name"], null, data[i]["name"], null));
            }

            // WatchUi.pushView(menu, new $.Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP);
            WatchUi.pushView(menu, new $.Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP);
        } else {
            System.println("Response: " + responseCode);            // print response code
        }
    }

    function makeRequest() as Void {
        var jsonSecrets = Application.loadResource(Rez.JsonData.jsonSecrets);

        var url = "https://api.todoist.com/rest/v1/projects";                         // set the url

        var params = {                                              // set the parameters
        };

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
            "Authorization" => "Bearer " + jsonSecrets["apiKey"]},
            // set response type
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        var responseCallback = method(:onReceive);                  // set responseCallback to
        // onReceive() method
        // Make the Communications.makeWebRequest() call
        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new TodoistIQView(), new TodoistIQDelegate() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as TodoistIQApp {
    return Application.getApp() as TodoistIQApp;
}
