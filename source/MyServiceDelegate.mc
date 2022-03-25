import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Application.Storage;



(:background)
class MyServiceDelegate extends System.ServiceDelegate {
private var long;
private var lat;

    function initialize() {
    	System.println("init service delegate");
        ServiceDelegate.initialize(); 
    }     

    function onTemporalEvent() as Void {
        System.println("temporal event");
        var myLastLocation = Application.Storage.getValue("location");
        lat = myLastLocation[0];
        long = myLastLocation[1];
        System.println("Latitude: " + lat); 
        System.println("Longitude: " + long); 
        
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
            }
        };
           
       Communications.makeWebRequest(
             "",
            {},
            options,
            method(:responseCallback)
        );
    }
	
    function responseCallback(responseCode, data as Dictionary) {
        // Do stuff with the response data here and send the data
        // payload back to the app that originated the background
        // process.
        System.println("response code "+responseCode);
        if (responseCode == 200) {
            System.println(data);
            var uvi = data["currentConditions"]["uvindex"];
            var maxuvi = data["days"][0]["uvindex"];
            var uviarr = [uvi,maxuvi];
            Background.exit(uviarr);
        }
    }
}
