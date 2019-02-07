package e.group.login;

import android.support.v4.app.FragmentActivity;
import android.os.Bundle;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;


public class MapsActivity extends FragmentActivity implements OnMapReadyCallback {

    private GoogleMap mMap;
    private FusedLocationProviderClient mFusedLocationClient;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Retrieve the content view that renders the map.
        setContentView(R.layout.activity_maps);
        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);

        //mGeoDataClient = Places.getGeoDataClient(this, null);

        // Get the SupportMapFragment and request notification
        // when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
    }


    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap) {
        // Add a marker in Sydney, Australia,
        // and move the map's camera to the same location.
        LatLng[] pins =new LatLng[10];
        pins[0] = new LatLng(55.9531, -3.1900);
        pins[1] = new LatLng(55.9600, -3.1900);
        pins[2] = new LatLng(55.9527, -3.1723);
        pins[3] = new LatLng(55.9531, -3.1900);
        pins[4] = new LatLng(55.9531, -3.1900);
        pins[5] = new LatLng(55.9531, -3.1900);
        pins[6] = new LatLng(55.9531, -3.1900);
        pins[7] = new LatLng(55.9531, -3.1900);
        pins[8] = new LatLng(55.9531, -3.1900);
        pins[9] = new LatLng(55.9531, -3.1900);
        for (int i = 0; i < pins.length; i++){
        googleMap.addMarker(new MarkerOptions().position(pins[i])
                .title("Marker in Edinburgh"));}
        googleMap.moveCamera(CameraUpdateFactory.newLatLng(pins[0]));
        //if (checkPermission("android.permission.ACCESS_FINE_LOCATION"), mFusedLocationClient.getInstanceId(),);
        //mFusedLocationClient.getLastLocation();
    }

    protected void createLocationRequest() {
        LocationRequest mLocationRequest = LocationRequest.create();
        mLocationRequest.setInterval(10000);
        mLocationRequest.setFastestInterval(5000);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    }
}
