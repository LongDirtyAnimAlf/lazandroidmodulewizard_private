unit location;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TGeoPoint2D = record
  latitude: double;
  longitude: double;
end;

TGpsStatusEvent = (gpsNone, gpsStarted, gpsStopped, gpsFirstFix, gpsSatelliteStatus);

TLocationChanged = procedure(Sender: TObject; latitude: double; longitude: double; altitude: double; address: string) of object;
TLocationStatusChanged = procedure(Sender: TObject; status: integer; provider: string; msgStatus: string) of object;
TLocationProviderEnabled = procedure(Sender: TObject; provider: string) of object;
TLocationProviderDisabled = procedure(Sender: TObject; provider: string) of object;
TOnGpsStatusChanged = procedure(Sender: TObject; countSatellites: integer; gpsStatusEvent: TGpsStatusEvent) of object;

TCriteriaAccuracy = (crCoarse {default Network-based/wi-fi}, crFine);

TMapType = (mtRoadmap, mtSatellite, mtTerrain, mtHybrid);

TProvider = (pvNetwork, pvGPS);

TPictureStyle = (pfDefault, pfMarkers, pfPath);

TMarkerHighlightColor = (markBlack, markBrown, markGreen, markPurple,
                         markYellow, markBlue, markGray, markOrange, markRed, markWhite);

{Draft Component code by "Lazarus Android Module Wizard" [8/11/2014 19:15:07]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jLocation = class(jControl)
 private
    FCriteriaAccuracy: TCriteriaAccuracy;
    FTimeForUpdates: int64;    // millsecs
    FDistanceForUpdates: int64;  //meters

    FMapType: TMapType;
    FMapZoom: integer;
    FMapWidth: integer;
    FMapHeight: integer;

    FOnLocationChanged: TLocationChanged;
    FOnLocationStatusChanged: TLocationStatusChanged;
    FOnLocationProviderEnabled: TLocationProviderEnabled;  //called when Gps is turned ON!!
    FOnLocationProviderDisabled: TLocationProviderDisabled; //called when Gps is turned OFF!!

    FOnGpsStatusChanged: TOnGpsStatusChanged;
    FGoogleMapsApiKey: string;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;

    function jCreate( _TimeForUpdates: int64; _DistanceForUpdates: int64; _CriteriaAccuracy: integer; _MapType: integer): jObject;
    procedure jFree();
    function StartTracker(): boolean;  overload;
    function StartTracker( lastKnownLocation: boolean ): boolean;  overload;
    function StartTrackerSingle(): boolean;
    procedure ShowLocationSouceSettings();
    procedure RequestLocationUpdates(); overload;
    procedure StopTracker();

    function GPSCreate(): boolean;

    procedure SetCriteriaAccuracy(_accuracy: TCriteriaAccuracy);

    function IsGPSProvider(): boolean;
    function IsNetProvider(): boolean;
    procedure SetTimeForUpdates(_time: int64);
    procedure SetDistanceForUpdates(_distance: int64);
    function GetLatitude(): double;
    function GetLongitude(): double;
    function GetAltitude(): double;
    function IsWifiEnabled(): boolean;
    procedure SetWifiEnabled(_status: boolean);
    function  GetGoogleMapsUrl(_latitude: double; _longitude: double): string; overload;
    function  GetGoogleMapsWebUrl(_latitude: double; _longitude: double; _zoom : boolean): string;
    procedure SetMapWidth(_mapwidth: integer);
    procedure SetMapHeight(_mapheight: integer);
    procedure SetMapZoom(_mapzoom: integer);
    procedure SetMapType(_maptype: TMapType);
    function GetAddress(): string; overload;
    function GetAddress(_latitude: double; _longitude: double): string; overload;
    function StartTracker(_locationName: string): boolean; overload;
    procedure RequestLocationUpdates(_provider: TProvider); overload;

    function GetLatitudeLongitude(_fullAddress: string): TDynArrayOfDouble;
    function GetGeoPoint2D(_fullAddress: string): TGeoPoint2D;

    function GetGoogleMapsUrl(_fullAddress: string): string; overload;
    function GetDistanceBetween(_startLatitude: double; _startLongitude: double; _endLatitude: double; _endLongitude: double): single;
    function GetDistanceTo(_latitude: double; _longitude: double): single;

    function GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): string; overload;

    function GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D): string; overload;
    function GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D; pictureStyle: TPictureStyle): string; overload;
    function GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D; pictureStyle: TPictureStyle; markerHighlightIndex: integer): string; overload;

    function GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; pictureStyle: TPictureStyle): string; overload;
    function GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; pictureStyle: TPictureStyle; _markerHighlightIndex: integer): string; overload;

    procedure SetMarkerHighlightColor(_color: TMarkerHighlightColor);
    function GetSatelliteCount(): integer;
    function GetSatelliteInfo(_index: integer): string;
    function GetTimeToFirstFix(): single;
    procedure SetGoogleMapsApiKey(_key: string);
    function GetAccuracy(): single; //by zebu1er
   // procedure Listen();

    procedure GenEvent_OnLocationChanged(Obj: TObject; latitude: double; longitude: double; altitude: double; address: string);
    procedure GenEvent_OnLocationStatusChanged(Obj: TObject; status: integer; provider: string; msgStatus: string);
    procedure GenEvent_OnLocationProviderEnabled(Obj: TObject; provider: string);
    procedure GenEvent_OnLocationProviderDisabled(Obj: TObject; provider: string);
    procedure GenEvent_OnGpsStatusChanged(Obj: TObject; countSatellites: integer; gpsStatusEvent: integer);

    property MapZoom: integer read FMapZoom write SetMapZoom;
    property MapWidth: integer read FMapWidth write SetMapWidth;
    property MapHeight: integer read FMapHeight write SetMapHeight;

 published

    property MapType: TMapType read FMapType write SetMapType;
    property CriteriaAccuracy: TCriteriaAccuracy read FCriteriaAccuracy write SetCriteriaAccuracy;

    property TimeForUpdates: int64 read FTimeForUpdates write SetTimeForUpdates;    // millsecs
    property DistanceForUpdates: int64 read FDistanceForUpdates write SetDistanceForUpdates;  //meters
    property GoogleMapsApiKey: string read FGoogleMapsApiKey write SetGoogleMapsApiKey;

    property OnLocationChanged: TLocationChanged read FOnLocationChanged write FOnLocationChanged;
    property OnLocationStatusChanged: TLocationStatusChanged read FOnLocationStatusChanged write FOnLocationStatusChanged;
    property OnLocationProviderEnabled: TLocationProviderEnabled read FOnLocationProviderEnabled write FOnLocationProviderEnabled;
    property OnLocationProviderDisabled: TLocationProviderDisabled read FOnLocationProviderDisabled write FOnLocationProviderDisabled;
    property OnGpsStatusChanged: TOnGpsStatusChanged read FOnGpsStatusChanged write FOnGpsStatusChanged;

end;

function jLocation_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _TimeForUpdates: int64; _DistanceForUpdates: int64; _CriteriaAccuracy: integer; _MapType: integer): jObject;
function jLocation_GetLatitudeLongitude(env: PJNIEnv; _jlocation: JObject; _locationAddress: string): TDynArrayOfDouble;

function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): string; overload;
function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _pathFlag: integer): string; overload;
function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _pathFlag: integer; _markerHighlightIndex: integer): string; overload;
//procedure jLocation_Listen(env: PJNIEnv; _jlocation: JObject);

function GeoPoint2D(latitute: double; longitude: double): TGeoPoint2D;

implementation

function GeoPoint2D(latitute: double; longitude: double): TGeoPoint2D;
begin
  Result.latitude:= latitute;
  Result.longitude:= longitude;
end;

{---------  jLocation  --------------}

constructor jLocation.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FCriteriaAccuracy:= crCoarse;  //{default Network-based/wi-fi}
  FMapType:= mtRoadmap;
  FTimeForUpdates:= Trunc((1000 * 60 * 1)/4); // millsecs   {default = 1/4 minute};
  FDistanceForUpdates:= 1;  //meters
end;

destructor jLocation.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
        if FjObject  <> nil then
        begin
           jFree();
           FjObject := nil;
        end;
  end;
  //you others free code here...
  inherited Destroy;
end;

procedure jLocation.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject := jCreate(FTimeForUpdates ,FDistanceForUpdates ,Ord(FCriteriaAccuracy) ,Ord(FMapType));

  if FjObject = nil then exit;

  if FGoogleMapsApiKey <> '' then
     jni_proc_t(FjEnv, FjObject, 'SetGoogleMapsApiKey', FGoogleMapsApiKey);

  FInitialized:= True;

end;

function jLocation.jCreate( _TimeForUpdates: int64; _DistanceForUpdates: int64; _CriteriaAccuracy: integer; _MapType: integer): jObject;
begin
   Result:= jLocation_jCreate(FjEnv, FjThis , int64(Self) ,_TimeForUpdates ,_DistanceForUpdates ,_CriteriaAccuracy ,_MapType);
end;

function jLocation.GPSCreate(): boolean;
begin
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjThis, 'GPSCreate');
end;

procedure jLocation.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'jFree' );
end;

function jLocation.StartTracker(): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jni_func_z_out_z(FjEnv, FjObject, 'StartTracker', false);
end;

function jLocation.StartTrackerSingle(): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'StartTrackerSingle');
end;

function jLocation.StartTracker( lastKnownLocation : boolean ): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jni_func_z_out_z(FjEnv, FjObject, 'StartTracker', lastKnownLocation );
end;

procedure jLocation.ShowLocationSouceSettings();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'ShowLocationSourceSettings' );
end;

procedure jLocation.RequestLocationUpdates();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'RequestLocationUpdates' );
end;

procedure jLocation.StopTracker();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'StopTracker' );
end;

procedure jLocation.SetCriteriaAccuracy(_accuracy: TCriteriaAccuracy);
begin
  //in designing component state: set value here...
  FCriteriaAccuracy:= _accuracy;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetCriteriaAccuracy', Ord(_accuracy));
end;

function jLocation.IsGPSProvider(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'IsGPSProvider' );
end;

function jLocation.IsNetProvider(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'IsNetProvider' );
end;

procedure jLocation.SetTimeForUpdates(_time: int64);
begin
  //in designing component state: set value here...
  FTimeForUpdates:= _time;
  if FInitialized then
     jni_proc_j(FjEnv, FjObject, 'SetTimeForUpdates', _time);
end;

procedure jLocation.SetDistanceForUpdates(_distance: int64);
begin
  //in designing component state: set value here...
  FDistanceForUpdates:= _distance;
  if FInitialized then
     jni_proc_j(FjEnv, FjObject, 'SetDistanceForUpdates', _distance);
end;

function jLocation.GetLatitude(): double;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_d(FjEnv, FjObject, 'GetLatitude' );
end;

function jLocation.GetLongitude(): double;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_d(FjEnv, FjObject, 'GetLongitude' );
end;

function jLocation.GetAltitude(): double;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_d(FjEnv, FjObject, 'GetAltitude' );
end;

function jLocation.IsWifiEnabled(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'IsWifiEnabled' );
end;

procedure jLocation.SetWifiEnabled(_status: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(FjEnv, FjObject, 'SetWifiEnabled', _status);
end;

function jLocation.GetGoogleMapsUrl(_latitude: double; _longitude: double): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_dd_out_t(FjEnv, FjObject, 'GetGoogleMapsUrl', _latitude ,_longitude);
end;

function jLocation.GetGoogleMapsWebUrl(_latitude : double; _longitude: double; _zoom : boolean): string;
begin
 if FInitialized then
  Result:= jni_func_ffz_out_t(FjEnv, FjObject, 'GetGoogleMapsWebUrl', _latitude, _longitude, _zoom);
end;

procedure jLocation.SetMapWidth(_mapwidth: integer);
begin
  //in designing component state: set value here...
  FMapWidth:= _mapwidth;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetMapWidth', _mapwidth);
end;

procedure jLocation.SetMapHeight(_mapheight: integer);
begin
  //in designing component state: set value here...
  FMapHeight:=_mapheight;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetMapHeight', _mapheight);
end;

procedure jLocation.SetMapZoom(_mapzoom: integer);
begin
  //in designing component state: set value here...
  FMapZoom:= _mapzoom;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetMapZoom', _mapzoom);
end;

procedure jLocation.SetMapType(_maptype: TMapType);
begin
  //in designing component state: set value here...
  FMapType:= _maptype;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetMapType', Ord(_maptype));
end;

function jLocation.GetAddress(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetAddress' );
end;

function jLocation.GetAddress(_latitude: double; _longitude: double): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_dd_out_t(FjEnv, FjObject, 'GetAddress', _latitude ,_longitude);
end;

function jLocation.StartTracker(_locationName: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_z(FjEnv, FjObject, 'StartTracker', _locationName);
end;

procedure jLocation.RequestLocationUpdates(_provider: TProvider);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'RequestLocationUpdates', Ord(_provider));
end;

function jLocation.GetLatitudeLongitude(_fullAddress: string): TDynArrayOfDouble;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetLatitudeLongitude(FjEnv, FjObject, _fullAddress);
end;

function jLocation.GetGeoPoint2D(_fullAddress: string): TGeoPoint2D;
var
  ll: TDynArrayOfDouble;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
   ll:= jLocation_GetLatitudeLongitude(FjEnv, FjObject, _fullAddress);
   Result.latitude:= ll[0];
   Result.longitude:= ll[1];
  end;
  SetLength(ll, 0);
end;

function jLocation.GetGoogleMapsUrl(_fullAddress: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_t(FjEnv, FjObject, 'GetGoogleMapsUrl', _fullAddress);
end;

function jLocation.GetDistanceBetween(_startLatitude: double; _startLongitude: double; _endLatitude: double; _endLongitude: double): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_dddd_out_f(FjEnv, FjObject, 'GetDistanceBetween', _startLatitude ,_startLongitude ,_endLatitude ,_endLongitude);
end;

function jLocation.GetDistanceTo(_latitude: double; _longitude: double): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_dd_out_f(FjEnv, FjObject, 'GetDistanceTo', _latitude ,_longitude);
end;

function jLocation.GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, _latitude ,_longitude);
end;

function jLocation.GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D): string;
var
  count, i: integer;
  latitude: TDynArrayOfDouble;
  longitude: TDynArrayOfDouble;
  p: TGeoPoint2D;
begin
  if FInitialized then
  begin
    count:= Length(geoPoints);
    SetLength(latitude,  count);
    SetLength(longitude,  count);
    for i:= 0 to count-1 do
    begin
      p:= geoPoints[i];
      latitude[i]:= p.latitude;
      longitude[i]:= p.longitude;
    end;
    Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, latitude ,longitude);
    SetLength(latitude,  0);
    SetLength(longitude, 0);
  end;
end;

function jLocation.GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D; pictureStyle: TPictureStyle): string;
var
  count, i: integer;
  latitude: TDynArrayOfDouble;
  longitude: TDynArrayOfDouble;
  p: TGeoPoint2D;
begin
  if FInitialized then
  begin
    count:= Length(geoPoints);
    SetLength(latitude,  count);
    SetLength(longitude,  count);
    for i:= 0 to count-1 do
    begin
      p:= geoPoints[i];
      latitude[i]:= p.latitude;
      longitude[i]:= p.longitude;
    end;
    Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, latitude ,longitude, Ord(pictureStyle));
    SetLength(latitude,  0);
    SetLength(longitude, 0);
  end;
end;

function jLocation.GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D; pictureStyle: TPictureStyle; markerHighlightIndex: integer): string;
var
  count, i: integer;
  latitude: TDynArrayOfDouble;
  longitude: TDynArrayOfDouble;
  p: TGeoPoint2D;
begin
  if FInitialized then
  begin
    count:= Length(geoPoints);
    SetLength(latitude,  count);
    SetLength(longitude,  count);
    for i:= 0 to count-1 do
    begin
      p:= geoPoints[i];
      latitude[i]:= p.latitude;
      longitude[i]:= p.longitude;
    end;
    Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, latitude ,longitude, Ord(pictureStyle), markerHighlightIndex);
    SetLength(latitude,  0);
    SetLength(longitude, 0);
  end;
end;

function jLocation.GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; pictureStyle: TPictureStyle): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, _latitude ,_longitude, Ord(pictureStyle));
end;

function jLocation.GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; pictureStyle: TPictureStyle; _markerHighlightIndex: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, _latitude ,_longitude ,Ord(pictureStyle) ,_markerHighlightIndex);
end;

procedure jLocation.SetMarkerHighlightColor(_color: TMarkerHighlightColor);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetMarkerHighlightColor', Ord(_color) );
end;

function jLocation.GetSatelliteCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetSatelliteCount');
end;

function jLocation.GetSatelliteInfo(_index: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_i_out_t(FjEnv, FjObject, 'GetSatelliteInfo', _index);
end;

function jLocation.GetTimeToFirstFix(): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_f(FjEnv, FjObject, 'GetTimeToFirstFix');
end;

{
procedure jLocation.Listen();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLocation_Listen(FjEnv, FjObject);
end;
}

procedure jLocation.SetGoogleMapsApiKey(_key: string);
begin
  //in designing component state: set value here...
  FGoogleMapsApiKey:= _key;
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SetGoogleMapsApiKey', _key);
end;

function jLocation.GetAccuracy(): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_f(FjEnv, FjObject, 'GetAccuracy');
end;

procedure jLocation.GenEvent_OnLocationChanged(Obj: TObject; latitude: double; longitude: double; altitude: double; address: string);
begin
   if Assigned(FOnLocationChanged) then FOnLocationChanged(Obj, latitude, longitude, altitude, address);
end;

procedure jLocation.GenEvent_OnLocationStatusChanged(Obj: TObject; status: integer; provider: string; msgStatus: string);
begin
   if Assigned(FOnLocationStatusChanged) then FOnLocationStatusChanged(Obj, status, provider, msgStatus);
end;

procedure jLocation.GenEvent_OnLocationProviderEnabled(Obj: TObject; provider: string);
begin
   if Assigned(FOnLocationProviderEnabled) then FOnLocationProviderEnabled(Obj, provider);
end;

procedure jLocation.GenEvent_OnLocationProviderDisabled(Obj: TObject; provider: string);
begin
   if Assigned(FOnLocationProviderDisabled) then FOnLocationProviderDisabled(Obj, provider);
end;

procedure jLocation.GenEvent_OnGpsStatusChanged(Obj: TObject; countSatellites: integer; gpsStatusEvent: integer);
begin
   if Assigned(FOnGpsStatusChanged) then FOnGpsStatusChanged(Obj, countSatellites, TGpsStatusEvent(gpsStatusEvent));
end;


{-------- jLocation_JNI_Bridge ----------}

function jLocation_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _TimeForUpdates: int64; _DistanceForUpdates: int64; _CriteriaAccuracy: integer; _MapType: integer): jObject;
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].j:= _TimeForUpdates;
  jParams[2].j:= _DistanceForUpdates;
  jParams[3].i:= _CriteriaAccuracy;
  jParams[4].i:= _MapType;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jLocation_jCreate', '(JJJII)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

function jLocation_GetLatitudeLongitude(env: PJNIEnv; _jlocation: JObject; _locationAddress: string): TDynArrayOfDouble;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_locationAddress));
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLatitudeLongitude', '(Ljava/lang/String;)[D');
  jResultArray:= env^.CallObjectMethodA(env, _jlocation, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetDoubleArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
   env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  newSize0:= Length(_latitude);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_latitude[0] {source});
  jParams[0].l:= jNewArray0;
  newSize1:= Length(_longitude);
  jNewArray1:= env^.NewDoubleArray(env, newSize1);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray1, 0 , newSize1, @_longitude[0] {source});
  jParams[1].l:= jNewArray1;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGoogleMapsUrl', '([D[D)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _pathFlag: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  newSize0:= Length(_latitude);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_latitude[0] {source});
  jParams[0].l:= jNewArray0;
  newSize1:= Length(_longitude);
  jNewArray1:= env^.NewDoubleArray(env, newSize1);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray1, 0 , newSize1, @_longitude[0] {source});
  jParams[1].l:= jNewArray1;
  jParams[2].i:= _pathFlag;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGoogleMapsUrl', '([D[DI)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _pathFlag: integer; _markerHighlightIndex: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  newSize0:= Length(_latitude);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_latitude[0] {source});
  jParams[0].l:= jNewArray0;
  newSize1:= Length(_longitude);
  jNewArray1:= env^.NewDoubleArray(env, newSize1);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray1, 0 , newSize1, @_longitude[0] {source});
  jParams[1].l:= jNewArray1;
  jParams[2].i:= _pathFlag;
  jParams[3].i:= _markerHighlightIndex;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGoogleMapsUrl', '([D[DII)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

{
procedure jLocation_Listen(env: PJNIEnv; _jlocation: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'Listen', '()V');
  env^.CallVoidMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;
}

end.
