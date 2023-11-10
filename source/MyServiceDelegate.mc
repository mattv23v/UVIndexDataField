
import Toybox.Background;
import Toybox.System;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.Communications;

(:background)
class MyServiceDelegate extends System.ServiceDelegate {
private var long;
private var lat;

    function initialize() {
    	System.println("init service delegate");
        ServiceDelegate.initialize(); 
    }     

    function onTemporalEvent()  {
        System.println("temporal event");
        var myLastLocation = Application.Storage.getValue("location");
        if (myLastLocation != null){
            lat = myLastLocation[0];
            long = myLastLocation[1];
            System.println("Latitude: " + lat); 
            System.println("Longitude: " + long); 
        }

        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
            }
        };
           
       Communications.makeWebRequest(
           "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"+lat+"%2C"+long+"/today?unitGroup=metric&elements=datetime%2Cuvindex&include=days%2Ccurrent&key=2NRMDC3QHQYXXDPBM3B5BMAF3&contentType=json",
            {},
            options,
            method(:responseCallback)
        );
    }

    function responseCallback(responseCode as Lang.Number, data as Null or Lang.Dictionary or Lang.String)as Void {
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
