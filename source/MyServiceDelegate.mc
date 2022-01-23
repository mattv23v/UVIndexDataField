import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Application.Storage;



(:background)
class MyServiceDelegate extends System.ServiceDelegate {
    // When a scheduled background event triggers, make a request to
    // a service and handle the response with a callback function
    // within this delegate.
    private var long;
    private var lat;
    function initialize() {
    	System.println("init service delegate");
        ServiceDelegate.initialize(); 

        
    }    

  function onTemporalEvent() as Void{
    System.println("temporal event");
    var myLastLocation = Application.Storage.getValue("location");
    System.println("Latitude: " + myLastLocation[0]); 
    System.println("Longitude: " + myLastLocation[1]); 

      var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
                "x-access-token" => "a41aafda1938afa838bf459f07bc924c"
                
            }
        };

       Communications.makeWebRequest(
            //"https://api.openweathermap.org/data/2.5/onecall?lat=35.78&lon=-78.64&exclude=alerts,minutely,hourly,daily&appid=2ca5acab977c95097e264298dd95ec77",
            //"https://api.openweathermap.org/data/2.5/weather?q=Raleigh&appid=2ca5acab977c95097e264298dd95ec77",
            //"https://api.openuv.io/api/v1/uv?lat=36.34&lng=-78.342T10%3A50%3A52.283Z",
            "https://api.openweathermap.org/data/2.5/onecall?lat=35.78&lon=-78.64&exclude=alerts,minutely,hourly&appid=2ca5acab977c95097e264298dd95ec77",

            {},
            options,
            method(:responseCallback)
        );
    }
	
    function responseCallback(responseCode, data as Dictionary) {
        // Do stuff with the response data here and send the data
        // payload back to the app that originated the background
        // process.
        System.println( data["daily"][0]["uvi"] ); 
        System.println("response code "+responseCode);
        //System.println("recieved data: "+data);
         if (responseCode == 200) {
         /*var uvi = data.get("result").get("uv");
         var maxuv = data.get("result").get("uv_max");
         var uvtime = data.get("result").get("uv_max_time");
         System.println("cur uvi: "+uvi);
         System.println("max uvi: "+maxuv);
         System.println("max uvi time: "+uvtime);*/
         //var uvi = data.get("current").get("uvi");
         var uvi = data["current"]["uvi"];
         var maxuvi =  data["daily"][0]["uvi"];
         var uviarr = [uvi,maxuvi];
         Background.exit(uviarr);
         }
    }
}