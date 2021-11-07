import Toybox.Lang;
import Toybox.WatchUi;

class TodoistIQDelegate extends WatchUi.BehaviorDelegate {
    private var _notify as Method() as Void;

    function initialize(handler as Method(args as Dictionary or String or Null) as Void) {
        BehaviorDelegate.initialize();
        _notify = handler;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TodoistIQMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    //! Handle a button being pressed and released
    //! @param evt The key event that occurred
    //! @return true if handled, false otherwise
    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();
        if ((WatchUi.KEY_START == key) || (WatchUi.KEY_ENTER == key)) {
            _notify.invoke();
            return true;
        }
        return false;
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}
