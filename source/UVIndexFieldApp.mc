import Toybox.Application;
import Toybox.System;
import Toybox.Time;
import Toybox.Background;
import Toybox.Position;
import Toybox.Time.Gregorian;



(:background)
class UVIndexFieldApp extends Application.AppBase {
private var uv = [0,0];
private var inBackground = false;
const FIVE_MINUTES = new Time.Duration(5 * 60);
const THIRTY_MINUTES = new Time.Duration(30 * 60);

    public function initialize() {
        AppBase.initialize();
        System.println("initialize app");   
        var now = Time.now();
        var lastTime = Background.getLastTemporalEventTime();
        var isBTConnected= System.getDeviceSettings().phoneConnected;
        var curLoc = Activity.getActivityInfo().currentLocation;


        if ((isBTConnected and curLoc != null and 
             now.greaterThan(lastTime.add(THIRTY_MINUTES))) or  
             (isBTConnected and lastTime == null and curLoc != null)) {
            System.println("register event in initialize");   
            Background.registerForTemporalEvent(Time.now()); 
        }   
    }
 
    public function getServiceDelegate() as ServiceDelegate{
        inBackground=true;     
        return [new $.MyServiceDelegate()] as Array<ServiceDelegate>;
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {    
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        if(!inBackground) {
            System.println("exit app");
            Background.deleteTemporalEvent();
        }
    }
    
    public function getUv(){
        return uv;
    }
    
    function onBackgroundData(data as array) {
        System.println("callback");
        System.println(data);
        uv = data;
    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? { 
   	   return [ new UVIndexFieldView() ] as Array<Views or InputDelegates>;
    }
    
    function getApp() as UVIndexFieldApp {
        return Application.getApp() as UVIndexFieldApp;
    }

}

