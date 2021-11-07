import Toybox.Lang;
import Toybox.WatchUi;

class TodoistIQDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();

        makeRequest();
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
            for (var i = 0; i < data["projects"].size(); i++) {
                System.println(data["projects"][i]);                   // print success
                menu.addItem(new WatchUi.MenuItem(data["projects"][i]["name"], null, data["projects"][i]["name"], null));
            }

            // WatchUi.pushView(menu, new $.Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP);
            WatchUi.pushView(menu, new $.Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP);
        } else {
            System.println("Response: " + responseCode);            // print response code
            System.println("Response: " + data);            // print response code
        }
    }

    function makeRequest() as Void {
        var jsonSecrets = Application.loadResource(Rez.JsonData.jsonSecrets);

        var url = "https://api.todoist.com/sync/v8/sync";                         // set the url

        var params = {                                              // set the parameters
            "sync_token" => "*",
            "resource_types" => "[\"projects\"]"
        };
        System.println(params);                   // print success

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_POST,      // set HTTP method
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



    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TodoistIQMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}
