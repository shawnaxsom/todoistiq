//
// Copyright 2018-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

//! This is the menu input delegate for the main menu of the application
class Menu2TestMenu2Delegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        System.println("onSelect1");
        var id = item.getId() as String;
        var subLabel = item.getSubLabel() as String;
        if (id.equals("filters")) {
            // WatchUi.pushView(new WatchUi.Menu2({:title=>"Filters Menu"}), new $.TodoistIQFiltersDelegate(), WatchUi.SLIDE_BLINK);
            var delegate = new $.TodoistIQFiltersDelegate();
        } else if (id.equals("projects")) {
            WatchUi.pushView(new WatchUi.Menu2({:title=>"Projects Menu"}), new $.TodoistIQProjectsDelegate(), WatchUi.SLIDE_IMMEDIATE);
        } else if (id.equals("today")) {
            var tasksDelegate = new $.TodoistIQTasksDelegate();
            tasksDelegate.makeRequest("today");
        } else {
            System.println("unhandled option pressed:" + id);

            WatchUi.requestUpdate();
        }
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! This is the menu input delegate shared by all the basic sub-menus in the application
class Menu2SampleSubMenuDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        System.println("onSelect2");
        // For IconMenuItems, we will change to the next icon state.
        // This demonstrates a custom toggle operation using icons.
        // Static icons can also be used in this layout.
        if (item instanceof WatchUi.IconMenuItem) {
            item.setSubLabel((item.getIcon() as CustomIcon).nextState());
        }
        WatchUi.requestUpdate();
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    //! Handle the done item being selected
    public function onDone() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//! This is the menu input delegate for the custom sub-menu
class Menu2SampleCustomDelegate extends WatchUi.Menu2InputDelegate {

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    public function onSelect(item as MenuItem) as Void {
        System.println("onSelect3");
        var id = item.getId();

        // Create/push the custom menus
        // if (id == :basic) {
        //     $.pushBasicCustom();
        // } else if (id == :images) {
        //     $.pushImagesCustom();
        // } else if (id == :wrap) {
        //     $.pushWrapCustom();
        // }
    }

    //! Handle the back key being pressed
    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}


//! This is the custom Icon drawable. It fills the icon space with a color
//! to demonstrate its extents. It changes color each time the next state is
//! triggered, which is done when the item is selected in this application.
class CustomIcon extends WatchUi.Drawable {
    // This constant data stores the color state list.
    private const _colors = [Graphics.COLOR_RED, Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_GREEN,
                             Graphics.COLOR_BLUE, Graphics.COLOR_PURPLE] as Array<ColorValue>;
    private const _colorStrings = ["Red", "Orange", "Yellow", "Green", "Blue", "Violet"] as Array<String>;
    private var _index as Number;

    //! Constructor
    public function initialize() {
        Drawable.initialize({});
        _index = 0;
    }

    //! Advance to the next color state for the drawable
    //! @return The new color state
    public function nextState() as String {
        _index++;
        if (_index >= _colors.size()) {
            _index = 0;
        }

        return _colorStrings[_index];
    }

    //! Return the color string for the menu to use as its sublabel
    //! @return The current color
    public function getString() as String {
        return _colorStrings[_index];
    }

    //! Set the color for the current state and use dc.clear() to fill
    //! the drawable area with that color
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var color = _colors[_index];
        dc.setColor(color, color);
        dc.clear();
    }
}
