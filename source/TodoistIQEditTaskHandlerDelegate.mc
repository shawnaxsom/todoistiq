import Toybox.Lang;
import Toybox.WatchUi;

class TodoistIQEditTaskHandlerDelegate extends WatchUi.BehaviorDelegate {
    // TODO: for some reason this wasn't working as a non-static variable
    static var taskId = null;

    function initialize() {
        System.println("foobar4");
        BehaviorDelegate.initialize();
    }

    function setTaskId(taskIdToSet as String) {
        System.println("setTaskId5: " + taskIdToSet);
        TodoistIQEditTaskHandlerDelegate.taskId = taskIdToSet;
    }

    // set up the response callback function
    function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            System.println("Response: " + responseCode);            // print response code
        } else {
            System.println("Response: " + responseCode);            // print response code
            System.println("Response: " + data);            // print response code
        }

        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }


    function completeTask(id as String) as Void {
        System.println("foobar6");
        System.println("Completing task completeTask handler: " + id);
        var jsonSecrets = Application.loadResource(Rez.JsonData.jsonSecrets);

        var url = "https://api.todoist.com/rest/v1/tasks/" + id + "/close";

        var params = null;
        System.println(params);                   // print success

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_POST,      // set HTTP method
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

    public function onSelect(item as MenuItem) as Void {
        System.println("foobar7");
        var id = item.getId();
        
        if (id.equals("complete")) {
            System.println("Completing task onSelect delegate: " + TodoistIQEditTaskHandlerDelegate.taskId);
            completeTask(TodoistIQEditTaskHandlerDelegate.taskId);
        }
    }

    function onMenu() as Boolean {
        System.println("foobar8");
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TodoistIQMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
