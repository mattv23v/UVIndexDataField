import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Background;
import Toybox.System;
import Toybox.Application;
import Toybox.Weather;
import Toybox.Application.Storage;


class UVIndexFieldView extends WatchUi.DataField {
	hidden var uvIndexFieldApp as UVIndexFieldApp;
    private var _message as String = "Press menu or\nselect button";
	private var cond;
    function initialize() {
        DataField.initialize();
        uvIndexFieldApp = Application.getApp();

        }
        

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();
        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));
        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("curUVLabel");
            labelView.locY = labelView.locY - 16;
            labelView.locX = labelView.locX - 30;
            var labelView2 = View.findDrawableById("maxUVLabel");
            labelView2.locY = labelView2.locY - 16;
            labelView2.locX = labelView2.locX + 10;
            var valueView = View.findDrawableById("curUVValue");
            valueView.locY = valueView.locY + 7;
            valueView.locX = valueView.locX - 38;
            var valueView2 = View.findDrawableById("maxUVValue");
            valueView2.locY = valueView2.locY + 7;
            valueView2.locX = valueView2.locX + 12;

        }

        (View.findDrawableById("curUVLabel") as Text).setText(Rez.Strings.curUVLabel);
        (View.findDrawableById("maxUVLabel") as Text).setText(Rez.Strings.maxUVLabel);

    }

    function compute(info) {
        //need to simulate location
        if (info.currentLocation != null) {
        var myLocation = info.currentLocation.toDegrees();
        Storage.setValue("location", info.currentLocation.toDegrees());
       // System.println("Latitude: " + myLocation[0]); // e.g. 38.856147
        //System.println("Longitude: " + myLocation[1]); // e.g -94.800953
    }
    }
  
    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        // Set the background color 
        var bgColor = Graphics.COLOR_WHITE;
        var uv = uvIndexFieldApp.getUv();
        //(View.findDrawableById("Background") as Text).setColor(getBackgroundColor());
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

        // Set the foreground color and value
        var curUValue = View.findDrawableById("curUVValue") as Text;
        var maxUValue = View.findDrawableById("maxUVValue") as Text;
        curUValue.setColor(Graphics.COLOR_BLACK);
        maxUValue.setColor(Graphics.COLOR_BLACK);
      
     
        if (uv[0] !=null) {
            if (uv[0]<=2.99) {
                bgColor = Graphics.COLOR_GREEN;
            }
            else if (uv[0]>=3 && uv<=5.99){
                bgColor = Graphics.COLOR_YELLOW;
            }
            else if (uv[0]>=6 && uv<=7.99){
                bgColor = Graphics.COLOR_ORANGE;
            }
             else if (uv[0]>=8 && uv<=10.99){
                bgColor = Graphics.COLOR_RED;
            }
             else if (uv[0]>=11) {
                bgColor = Graphics.COLOR_PURPLE;
            }
        }
        curUValue.setText(uv[0].format("%.2f"));
        maxUValue.setText(uv[1].format("%.2f"));

        

        View.findDrawableById("Background").setColor(bgColor);
        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }
     
}