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

    public function initialize() {
        AppBase.initialize();
        System.println("initialize app"); 
        var savedUV = Application.Storage.getValue("lastuv");
        System.println("saved UV "+savedUV); 
        if (savedUV != null) {
            uv = savedUV;
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
        Storage.setValue("lastuv", uv);

    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? { 
   	   return [ new UVIndexFieldView() ] as Array<Views or InputDelegates>;
    }
    
    function getApp() as UVIndexFieldApp {
        return Application.getApp() as UVIndexFieldApp;
    }

    function registerEvent() {
        var lastTime = Background.getLastTemporalEventTime();
        var now = Time.now();
        //System.println("now "+now.value());
        //System.println("last time "+lastTime.value());
        if (lastTime == null or (now.value() > (lastTime.value()+900))) {
            Background.registerForTemporalEvent(Time.now());
        }

    }

}

