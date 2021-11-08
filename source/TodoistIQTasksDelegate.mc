import Toybox.Lang;
import Toybox.WatchUi;

class TodoistIQTasksDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();

        // makeRequest(filter);
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
                menu.addItem(new WatchUi.MenuItem(data[i]["content"], null, data[i]["id"], null));
            }

            // WatchUi.pushView(menu, new $.Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP);
            WatchUi.pushView(menu, new $.TodoistIQTasksHandlerDelegate(), WatchUi.SLIDE_UP);
        } else {
            System.println("Response: " + responseCode);            // print response code
            System.println("Response: " + data);            // print response code
        }
    }

    function makeRequest(filter as String) as Void {
        System.println("Filtering tasks by: " + filter);
        var jsonSecrets = Application.loadResource(Rez.JsonData.jsonSecrets);

        var querystring = "?filter=" + Communications.encodeURL(filter);
        var url = "https://api.todoist.com/rest/v1/tasks" + querystring;

        var params = {                                              // set the parameters
            // "filter" => filter,
        };
        System.println(params);                   // print success

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
            "Authorization" => "Bearer " + jsonSecrets["apiKey"]},
            // "filter" => "today",
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

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

class TodoistIQTasksHandlerDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();

        // makeRequest(filter);
    }

    public function onSelect(item as MenuItem) as Void {
        System.println("onSelect6");
        var id = item.getId();
        System.println("onSelect6 id: " + id);
        
        var delegate = new TodoistIQEditTaskDelegate();
        delegate.setTaskId(id);
        WatchUi.pushView(new TodoistIQView(), delegate, WatchUi.SLIDE_UP);
        delegate.loadMenu();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TodoistIQMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
