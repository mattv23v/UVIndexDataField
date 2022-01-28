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
    private var screenShape;
    function initialize() {
        DataField.initialize();
        uvIndexFieldApp = Application.getApp();
        screenShape = System.getDeviceSettings().screenShape;
        System.println(screenShape);
        /*
        SCREEN_SHAPE_ROUND	1	
        SCREEN_SHAPE_SEMI_ROUND	2	
        SCREEN_SHAPE_RECTANGLE	3	
        */

    }


    function compute(info) {
        //need to simulate location
        if (info.currentLocation != null) {
        var myLocation = info.currentLocation.toDegrees();
        Storage.setValue("location", info.currentLocation.toDegrees());
        }
    }

    function isSingleFieldLayout() {
        return (DataField.getObscurityFlags() == OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_BOTTOM | OBSCURE_RIGHT);
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        var currentLabel = "Current";
        var maxLabel = "Max";
        var uvLabel = "UV";
        var valueFormat = 0.2f;
        var width = dc.getWidth();
        var height = dc.getHeight();
        var textCenter = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
        var bgColor = Graphics.COLOR_WHITE;

        var uv = uvIndexFieldApp.getUv();
        var uvCur = uv[0].format("%.2f");
        var uvMax = uv[1].format("%.2f");

        if (uv[0] != null) {
            if (uv[0]<=2.99) {
                bgColor = Graphics.COLOR_GREEN;
            }
            else if (uv[0]>=3 && uv[0]<=5.99){
                bgColor = Graphics.COLOR_YELLOW;
            }
            else if (uv[0]>=6 && uv[0]<=7.99){
                bgColor = Graphics.COLOR_ORANGE;
            }
             else if (uv[0]>=8 && uv[0]<=10.99){
                bgColor = Graphics.COLOR_RED;
            }
             else if (uv[0]>=11) {
                bgColor = Graphics.COLOR_PURPLE;
            }
        }
        dc.setColor(Graphics.COLOR_TRANSPARENT, bgColor);
        dc.clear();
        //dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        //dc.fillRectangle (0, 0, width, height);
        //dc.setColor((backgroundColor == Graphics.COLOR_WHITE) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        System.println(uvCur);
        System.println("get width: "+width);
        System.println("shape: "+screenShape);
        if (screenShape == 3) {
            dc.drawText(width / 2-18, 5 + (height - 35) / 2, Graphics.FONT_TINY, currentLabel, textCenter);
            dc.drawText(width / 2+26, 5 + (height - 35) / 2, Graphics.FONT_TINY, maxLabel, textCenter);
            dc.drawText(width / 2+1, height / 2 + 4, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-27, height / 2 + 4, Graphics.FONT_TINY, uvCur, textCenter);
            dc.drawText(width / 2+28, height / 2 + 4, Graphics.FONT_TINY, uvMax, textCenter);
        }
        if (isSingleFieldLayout() and !(width == 390)) {
            dc.drawText(width / 2-40, height / 2 - 40, Graphics.FONT_LARGE, currentLabel, textCenter);
            dc.drawText(width / 2+55, height / 2 - 40, Graphics.FONT_LARGE, maxLabel, textCenter);
            dc.drawText(width / 2+1, height / 2 + 4, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-58, height / 2 + 7, Graphics.FONT_LARGE, uvCur, textCenter);
            dc.drawText(width / 2+57, height / 2 + 7, Graphics.FONT_LARGE, uvMax, textCenter);
         } 
        //do layout 390 x 390	
        if (isSingleFieldLayout() and (width == 390)) {
            dc.drawText(width / 2-60, height / 2 - 40, Graphics.FONT_LARGE, currentLabel, textCenter);
            dc.drawText(width / 2+85, height / 2 - 40, Graphics.FONT_LARGE, maxLabel, textCenter);
            dc.drawText(width / 2+1, height / 2 + 4, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-87, height / 2 + 7, Graphics.FONT_LARGE, uvCur, textCenter);
            dc.drawText(width / 2+88, height / 2 + 7, Graphics.FONT_LARGE, uvMax, textCenter);
         } 
        if (!isSingleFieldLayout() and (width == 390 or width == 194)) {
            dc.drawText(width / 2-30, 5 + (height - 35) / 2, Graphics.FONT_XTINY, currentLabel, textCenter);
            dc.drawText(width / 2+40, 5 + (height - 35) / 2, Graphics.FONT_XTINY, maxLabel, textCenter);
            dc.drawText(width / 2-2, height / 2 + 14, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-45, height / 2 + 14, Graphics.FONT_XTINY, uvCur, textCenter);
            dc.drawText(width / 2+42, height / 2 + 14, Graphics.FONT_XTINY, uvMax, textCenter);
        
        }
        //do layout 260 x 260, 280 x 280, 218 x 218		
       if (!isSingleFieldLayout() and (width == 240 or width == 280 or width == 119 
           or width == 129 or width == 260 or width == 218 or width == 108or width == 139)) {
            dc.drawText(width / 2-14, 5 + (height - 35) / 2, Graphics.FONT_XTINY, currentLabel, textCenter);
            dc.drawText(width / 2+30, 5 + (height - 35) / 2, Graphics.FONT_XTINY, maxLabel, textCenter);
            dc.drawText(width / 2+6, height / 2 + 4, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-24, height / 2 + 4, Graphics.FONT_XTINY, uvCur, textCenter);
            dc.drawText(width / 2+32, height / 2 + 4, Graphics.FONT_XTINY, uvMax, textCenter);
        }
        
   // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
   


        //var bgColor = Graphics.COLOR_WHITE;
      //  var uv = uvIndexFieldApp.getUv();
        //var curUValue = View.findDrawableById("curUVValue") as Text;
        //var maxUValue = View.findDrawableById("maxUVValue") as Text;

        //dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);


        //curUValue.setColor(Graphics.COLOR_BLACK);
       // maxUValue.setColor(Graphics.COLOR_BLACK);

       // curUValue.setText(uv[0].format("%.2f"));
        //maxUValue.setText(uv[1].format("%.2f"));

        //View.findDrawableById("Background").setColor(bgColor);
     
        // Call parent's onUpdate(dc) to redraw the layout
        //View.onUpdate(dc);
    }
     
}