import Toybox.Application;
import Toybox.System;
import Toybox.Time;
import Toybox.Background;
import Toybox.Position;



(:background)
class UVIndexFieldApp extends Application.AppBase {
private var uv = [0,0];
private var inBackground = false;
const FIVE_MINUTES = new Time.Duration(5 * 60);

    public function initialize() {
    
        AppBase.initialize();

        var lastTime = Background.getLastTemporalEventTime();
        if (lastTime != null) {
            // Events scheduled for a time in the past trigger immediately
            var nextTime = lastTime.add(FIVE_MINUTES);
            Background.registerForTemporalEvent(nextTime);
        } else {
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
            System.print("exit app");
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

