import Toybox.Graphics;
import Toybox.WatchUi;

class TodoistIQView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        System.println("loadOptions");
        // Generate a new Menu with a drawable Title
        // var menu = new WatchUi.Menu2({:title=>new $.DrawableMenuTitle()});
        var menu = new WatchUi.Menu2({});

        // This comes from the Menu2Sample app provided by the Garmin Connect IQ SDK
        // Add menu items for demonstrating toggles, checkbox and icon menu items
        menu.addItem(new WatchUi.MenuItem("Filters", null, "filters", null));
        menu.addItem(new WatchUi.MenuItem("Projects", null, "projects", null));

        WatchUi.pushView(menu, new $.Menu2TestMenu2Delegate(), WatchUi.SLIDE_UP);
        System.println("pushedView");
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
