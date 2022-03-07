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
import Toybox.Time.Gregorian;


class UVIndexFieldView extends WatchUi.DataField {
hidden var uvIndexFieldApp as UVIndexFieldApp;
private var _message as String = "Press menu or\nselect button";
private var screenShape;
private var registered = false;
const FIVE_MINUTES = new Time.Duration(5 * 60);
const SIXTY_MINUTES = new Time.Duration(60 * 60);
const THIRTY_MINUTES = new Time.Duration(30 * 60);

    function initialize() {
        DataField.initialize();
        uvIndexFieldApp = Application.getApp();
        screenShape = System.getDeviceSettings().screenShape;
        //System.println(screenShape);
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

  		var now = Time.now();
        var lastTime = Background.getLastTemporalEventTime();
        var isBTConnected= System.getDeviceSettings().phoneConnected;

        if ((isBTConnected and info.currentLocation != null and 
             now.greaterThan(lastTime.add(THIRTY_MINUTES))) or 
             (isBTConnected and lastTime == null and info.currentLocation != null)) {
            System.println("register event in view"); 
            Background.registerForTemporalEvent(Time.now()); 
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
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
       // do layout square bike computers
        if (screenShape == 3 and !(width == 282 or width == 140)) {
            dc.drawText(width / 2-22, 5 + (height - 35) / 2, Graphics.FONT_SMALL, currentLabel, textCenter);
            dc.drawText(width / 2+26, 5 + (height - 35) / 2, Graphics.FONT_SMALL, maxLabel, textCenter);
            dc.drawText(width / 2-2, height / 2 + 8, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-32, height / 2 + 8, Graphics.FONT_SMALL, uvCur, textCenter);
            dc.drawText(width / 2+28, height / 2 + 8, Graphics.FONT_SMALL, uvMax, textCenter);
        }
        if (screenShape == 3 and width == 282 or width == 140) {
            dc.drawText(width / 2-25, 5 + (height - 35) / 2, Graphics.FONT_SMALL, currentLabel, textCenter);
            dc.drawText(width / 2+34, 5 + (height - 35) / 2, Graphics.FONT_SMALL, maxLabel, textCenter);
            dc.drawText(width / 2-2, height / 2 + 8, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-37, height / 2 + 8, Graphics.FONT_SMALL, uvCur, textCenter);
            dc.drawText(width / 2+35, height / 2 + 8, Graphics.FONT_SMALL, uvMax, textCenter);
        }
        //do layout 390 x 390	
        if (isSingleFieldLayout() and (width == 390)) {
            dc.drawText(width / 2-60, height / 2 - 40, Graphics.FONT_LARGE, currentLabel, textCenter);
            dc.drawText(width / 2+85, height / 2 - 40, Graphics.FONT_LARGE, maxLabel, textCenter);
            dc.drawText(width / 2+1, height / 2 + 4, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-87, height / 2 + 7, Graphics.FONT_LARGE, uvCur, textCenter);
            dc.drawText(width / 2+88, height / 2 + 7, Graphics.FONT_LARGE, uvMax, textCenter);
         } 
        if (!isSingleFieldLayout() and (width == 390 or width == 194 or  width == 207 or  width == 416)) {
            dc.drawText(width / 2-30, 5 + (height - 35) / 2, Graphics.FONT_XTINY, currentLabel, textCenter);
            dc.drawText(width / 2+40, 5 + (height - 35) / 2, Graphics.FONT_XTINY, maxLabel, textCenter);
            dc.drawText(width / 2-2, height / 2 + 14, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-45, height / 2 + 14, Graphics.FONT_XTINY, uvCur, textCenter);
            dc.drawText(width / 2+42, height / 2 + 14, Graphics.FONT_XTINY, uvMax, textCenter);
        
        }
        if (isSingleFieldLayout() and (width == 416)) {
            dc.drawText(width / 2-60, height / 2 - 40, Graphics.FONT_LARGE, currentLabel, textCenter);
            dc.drawText(width / 2+85, height / 2 - 40, Graphics.FONT_LARGE, maxLabel, textCenter);
            dc.drawText(width / 2+1, height / 2 + 4, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-87, height / 2 + 7, Graphics.FONT_LARGE, uvCur, textCenter);
            dc.drawText(width / 2+88, height / 2 + 7, Graphics.FONT_LARGE, uvMax, textCenter);
        }

        //do layout 260 x 260, 280 x 280, 218 x 218		
       if (!isSingleFieldLayout() and (width == 240 or width == 280 or width == 119 
           or width == 129 or width == 260 or width == 218 or width == 108 or width == 139 )) {
            dc.drawText(width / 2-14, 5 + (height - 35) / 2, Graphics.FONT_XTINY, currentLabel, textCenter);
            dc.drawText(width / 2+30, 5 + (height - 35) / 2, Graphics.FONT_XTINY, maxLabel, textCenter);
            dc.drawText(width / 2+6, height / 2 + 4, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-24, height / 2 + 4, Graphics.FONT_XTINY, uvCur, textCenter);
            dc.drawText(width / 2+32, height / 2 + 4, Graphics.FONT_XTINY, uvMax, textCenter);
        }
        if (isSingleFieldLayout() and (width == 280 or width == 240 or width == 260)) {
            dc.drawText(width / 2-40, height / 2 - 40, Graphics.FONT_LARGE, currentLabel, textCenter);
            dc.drawText(width / 2+55, height / 2 - 40, Graphics.FONT_LARGE, maxLabel, textCenter);
            dc.drawText(width / 2+1, height / 2 + 4, Graphics.FONT_XTINY, uvLabel, textCenter);
            dc.drawText(width / 2-58, height / 2 + 7, Graphics.FONT_LARGE, uvCur, textCenter);
            dc.drawText(width / 2+57, height / 2 + 7, Graphics.FONT_LARGE, uvMax, textCenter);
         } 
    }
     
}