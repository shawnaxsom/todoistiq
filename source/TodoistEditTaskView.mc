import Toybox.Graphics;
import Toybox.WatchUi;

class TodoistIQEditTaskView extends WatchUi.View {
    var taskId = null;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    public function setTaskId(taskIdToSet as String) {
        System.println("Setting task: " + taskIdToSet);
        taskId = taskIdToSet;
    }

    // set up the response callback function
    function onShow() as Void {
        System.println("foobar1");
        // Generate a new Menu with a drawable Title
        // var menu = new WatchUi.Menu2({:title=>new $.DrawableMenuTitle()});
        var menu = new WatchUi.Menu2({});

        // This comes from the Menu2Sample app provided by the Garmin Connect IQ SDK
        // Add menu items for demonstrating toggles, checkbox and icon menu items
        menu.addItem(new WatchUi.MenuItem("Complete", null, "complete", null));

        // WatchUi.pushView(menu, new $.Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP);
        var handler = new $.TodoistIQEditTaskDelegate();
        WatchUi.pushView(menu, handler, WatchUi.SLIDE_UP);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function onMenu() as Boolean {
        System.println("foobar2");
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TodoistIQMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    // set up the response callback function
    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            System.println("Response: " + responseCode);            // print response code
        } else {
            System.println("Response: " + responseCode);            // print response code
            System.println("Response: " + data);            // print response code
        }
    }

    function completeTask(id as String) as Void {
        System.println("foobar6");
        System.println("Completing task completeTask: " + id);
        var jsonSecrets = Application.loadResource(Rez.JsonData.jsonSecrets);

        var url = "https://api.todoist.com/rest/v1/tasks/" + taskId + "/close";

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


    function onMenuItem(item as Symbol) as Void {
        System.println("foobar3");
        if (item == "complete") {
            System.println("Completing task onMenuItem: " + taskId);
            completeTask(taskId);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}