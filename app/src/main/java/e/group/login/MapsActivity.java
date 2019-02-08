package e.group.login;

import android.Manifest;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.FragmentActivity;
import android.support.v4.content.ContextCompat;
import android.widget.Toast;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback, GoogleMap.OnMyLocationButtonClickListener, GoogleMap.OnMyLocationClickListener {

    private GoogleMap mMap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED)
            mMap.setMyLocationEnabled(true);
        //mMap.setOnMyLocationButtonClickListener(this);
        //mMap.setOnMyLocationClickListener(this);

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
        mMap = googleMap;
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED)
            mMap.setMyLocationEnabled(true);

        //mMap.setOnMyLocationButtonClickListener(this);
        //mMap.setOnMyLocationClickListener(this);

        // Add a marker in Sydney and move the camera
        LatLng pins[] = new LatLng[20];
        pins[0] = new LatLng(55.9527, -3.1723);
        pins[1] = new LatLng(55.9521, -3.1893);
        pins[2] = new LatLng(55.9554, -3.1914);
        pins[3] = new LatLng(55.9456, -3.2183);
        pins[4] = new LatLng(55.9519, -3.2073);
        pins[5] = new LatLng(55.9473, -3.2050);
        pins[6] = new LatLng(55.9486, -3.2116);
        pins[7] = new LatLng(55.9441, -3.2035);
        pins[8] = new LatLng(55.9392, -3.1724);
        pins[9] = new LatLng(55.9706, -3.1717);
        pins[10] = new LatLng(55.9486, -3.1999);
        pins[11] = new LatLng(55.9422, -3.2693);
        pins[12] = new LatLng(55.9472, -3.1892);
        pins[13] = new LatLng(55.9509, -3.1957);
        pins[14] = new LatLng(55.9225, -3.1755);
        pins[15] = new LatLng(55.9562, -3.1861);
        mMap.addMarker(new MarkerOptions().position(pins[0]).title("Holyrood Palace Station"));
        mMap.addMarker(new MarkerOptions().position(pins[1]).title("Waverley steps Station"));
        mMap.addMarker(new MarkerOptions().position(pins[2]).title("St Andrews square Station"));
        mMap.addMarker(new MarkerOptions().position(pins[3]).title("Haymarket Station"));
        mMap.addMarker(new MarkerOptions().position(pins[4]).title("Charlotte square Station"));
        mMap.addMarker(new MarkerOptions().position(pins[5]).title("Usher Hall Station"));
        mMap.addMarker(new MarkerOptions().position(pins[6]).title("West End Station"));
        mMap.addMarker(new MarkerOptions().position(pins[7]).title("Fountainbridge Station"));
        mMap.addMarker(new MarkerOptions().position(pins[8]).title("Commonwealth Pool Station"));
        mMap.addMarker(new MarkerOptions().position(pins[9]).title("Leith Station"));
        mMap.addMarker(new MarkerOptions().position(pins[10]).title("Edinburgh Castle Station"));
        mMap.addMarker(new MarkerOptions().position(pins[11]).title("Edinburgh Zoo Station"));
        mMap.addMarker(new MarkerOptions().position(pins[12]).title("Edinburgh Museum Station"));
        mMap.addMarker(new MarkerOptions().position(pins[13]).title("National Art Gallery Station"));
        mMap.addMarker(new MarkerOptions().position(pins[14]).title("Kings Buildings Station"));
        mMap.addMarker(new MarkerOptions().position(pins[15]).title("Omni Centre Station"));


        mMap.moveCamera(CameraUpdateFactory.newLatLng(pins[0]));

    }

    @Override
    public void onMyLocationClick(@NonNull Location location) {
        Toast.makeText(this, "Current location:\n" + location, Toast.LENGTH_LONG).show();
    }

    @Override
    public boolean onMyLocationButtonClick() {
        Toast.makeText(this, "MyLocation button clicked", Toast.LENGTH_SHORT).show();
        // Return false so that we don't consume the event and the default behavior still occurs
        // (the camera animates to the user's current position).
        return false;
    }
}
