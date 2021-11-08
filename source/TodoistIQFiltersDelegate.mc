import Toybox.Lang;
import Toybox.WatchUi;

class TodoistIQFiltersDelegate extends WatchUi.BehaviorDelegate {
    var filters = null;

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

            // Treat Today like a filter
            menu.addItem(new WatchUi.MenuItem("Today", "filter", "today", null));

            System.println("Request Successful");                   // print success
            filters = data["filters"];
            for (var i = 0; i < filters.size(); i++) {
                System.println(data["filters"][i]);                   // print success
                menu.addItem(new WatchUi.MenuItem(data["filters"][i]["name"], "filter", data["filters"][i]["name"], null));
            }

            // WatchUi.pushView(menu, new $.Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP);
            var handler = new $.TodoistIQFiltersHandlerDelegate();
            handler.setFilters(filters);
            WatchUi.switchToView(menu, handler, WatchUi.SLIDE_UP);
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
            "resource_types" => "[\"filters\"]"
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

    public function onSelect(item as MenuItem) as Void {
        System.println("onSelect4");
        var id = item.getId();
        System.println("Selected: " + id);
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
