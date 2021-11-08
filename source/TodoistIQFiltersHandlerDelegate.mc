import Toybox.Lang;
import Toybox.WatchUi;

class TodoistIQFiltersHandlerDelegate extends WatchUi.BehaviorDelegate {
    var filters = null;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function setFilters(filtersToSet as Dictionary?) {
        filters = filtersToSet;
    }

    public function onSelect(item as MenuItem) as Void {
        System.println("onSelect5");
        var id = item.getId();
        System.println("Selected: " + id);

        var tasksDelegate = new $.TodoistIQTasksDelegate();

        System.println("filters.size(): " + filters.size());
        
        if (id.equals("today")) {
            tasksDelegate.makeRequest("(today | overdue)");
        } else {
            for (var i = 0; i < filters.size(); i++) {
                System.println("filter: " + filters[i]["name"]);
                if (id.equals(filters[i]["name"])) {
                    tasksDelegate.makeRequest(filters[i]["query"]);
                    break;
                }
            }
        }

        // WatchUi.switchToView(new WatchUi.Menu2({:title=>"Tasks Menus"}), tasksDelegate, WatchUi.SLIDE_UP);
        // WatchUi.pushView(new WatchUi.Menu2({:title=>"Tasks Menus"}), tasksDelegate, WatchUi.SLIDE_UP);
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
