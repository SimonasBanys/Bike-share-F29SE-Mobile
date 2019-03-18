package e.group.login;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.GoogleMap.OnMyLocationButtonClickListener;
import com.google.android.gms.maps.GoogleMap.OnMyLocationClickListener;
import com.google.android.gms.maps.LocationSource;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationProvider;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class MapsActivity extends AppCompatActivity
        implements
        OnMyLocationButtonClickListener,
        OnMyLocationClickListener,
        OnMapReadyCallback,
        ActivityCompat.OnRequestPermissionsResultCallback {

    /**
     * Request code for location permission request.
     *
     * @see #onRequestPermissionsResult(int, String[], int[])
     */
    private static final int LOCATION_PERMISSION_REQUEST_CODE = 1;

    /**
     * Flag indicating whether a requested permission has been denied after returning in
     * {@link #onRequestPermissionsResult(int, String[], int[])}.
     */
    private boolean mPermissionDenied = false;

    private GoogleMap mMap;
    private ArrayList<Station> stations = new ArrayList<>();
    private ArrayList<Marker> mark = new ArrayList<>();
    Button book;
    Button report;
    Button logout;
    private SessionHandler session;
    private int j;
    private EditText problem;
    private String problem_url = "http://www2.macs.hw.ac.uk/~sb93/report.php";

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);
        session = new SessionHandler(getApplicationContext());
        book = findViewById(R.id.book);
        report = findViewById(R.id.report);
        logout = findViewById(R.id.logout);
        problem = findViewById(R.id.etProblem);
        logout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                session.logoutUser();
                Intent i = new Intent(MapsActivity.this, LoginActivity.class);
                startActivity(i);
                finish();
            }
        });

        book.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (stations.get(j).bookCycle()){
                    Toast.makeText(getApplicationContext(), "Bike booked", Toast.LENGTH_LONG).show();
                    mark.get(j).remove();
                    mark.get(j).setSnippet("Bikes available: " + stations.get(j).getBikes() + ";\r Bike spaces available: " +stations.get(j).getSpace() + ";");
                    mMap.addMarker(new MarkerOptions().position(mark.get(j).getPosition()).title(mark.get(j).getTitle()).snippet(mark.get(j).getSnippet()).icon(BitmapDescriptorFactory.fromAsset("bike.png")));
                } else Toast.makeText(getApplicationContext(), "Cannot book bike", Toast.LENGTH_LONG).show();
            }
        });

        report.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String prob;
                String user = session.getUserDetails().getUsername();
                int bikeID = (int) (Math.random()*24)+1;
                JSONObject rep = new JSONObject();
                if (problem.getText().toString().toLowerCase().trim().equals("")){
                    Toast.makeText(getApplicationContext(), "Please enter your problem", Toast.LENGTH_LONG).show();
                    problem.requestFocus();
                } else{
                    prob = problem.getText().toString().toLowerCase().trim();
                    try {
                        rep.put("user", user);
                        rep.put("problem", prob);
                        rep.put("bike", bikeID);
                    } catch (Exception e){Toast.makeText(getApplicationContext(), e.toString(), Toast.LENGTH_LONG).show();}
                    JsonObjectRequest jsArrayRequest = new JsonObjectRequest
                            (Request.Method.POST, problem_url, rep, new Response.Listener<JSONObject>() {
                                @Override
                                public void onResponse(JSONObject response) {

                                    try {
                                        if (response.getInt("status") == 0) {
                                            Toast.makeText(getApplicationContext(), "Problem successfully reported", Toast.LENGTH_LONG).show();
                                        }else{
                                            Toast.makeText(getApplicationContext(),
                                                    response.getString("message"), Toast.LENGTH_SHORT).show();
                                        }
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                }
                            }, new Response.ErrorListener() {
                                @Override
                                public void onErrorResponse(VolleyError error) {
                                    Toast.makeText(getApplicationContext(),
                                            error.getMessage(), Toast.LENGTH_SHORT).show();

                                }
                            });
                    MySingleton.getInstance(getApplicationContext()).addToRequestQueue(jsArrayRequest);
                }

            }
        });

        SupportMapFragment mapFragment =
                (SupportMapFragment) getSupportFragmentManager().findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
    }

    @Override
    public void onMapReady(GoogleMap map) {
        mMap = map;
        stations.add(new Station(55.9527, -3.1723, "Holyrood Palace Station", 7, 3));
        stations.add(new Station(55.9521, -3.1893, "Waverley steps Station", 4,9));
        stations.add(new Station(55.9554, -3.1914, "St Andrews square Station", 9,4));
        stations.add(new Station(55.9456, -3.2183, "Haymarket Station", 1, 13));
        stations.add(new Station(55.9519, -3.2073, "Charlotte square Station", 4, 4));
        stations.add(new Station(55.9473, -3.2050, "Usher Hall Station", 1, 9));
        stations.add(new Station(55.9486, -3.2116, "West End Station", 1, 16));
        stations.add(new Station(55.9441, -3.2035, "Fountainbridge Station", 7, 2));
        stations.add(new Station(55.9392, -3.1724, "Commonwealth Pool Station", 14,2));
        stations.add(new Station(55.9706, -3.1717, "Leith Station", 7, 10));
        stations.add(new Station(55.9486, -3.1999, "Edinburgh Castle Station", 6, 10));
        stations.add(new Station(55.9422, -3.2693, "Edinburgh Zoo Station", 12, 6));
        stations.add(new Station(55.9472, -3.1892, "Edinburgh Museum Station", 6, 2));
        stations.add(new Station(55.9509, -3.1957, "National Art Gallery Station", 12, 1));
        stations.add(new Station(55.9225, -3.1755, "Kings Buildings Station", 2, 11));
        stations.add(new Station(55.9562, -3.1861, "Omni Centre Station", 0, 20));
        for (int i = 0; i < stations.size(); i++){
            mark.add(mMap.addMarker(new MarkerOptions().position(stations.get(i).getCoord()).title(stations.get(i).getLabel()).draggable(false).snippet("Bikes available: " + stations.get(i).getBikes() + ";\r Bike spaces available: " +stations.get(i).getSpace() + ";").icon(BitmapDescriptorFactory.fromAsset("bike.png"))));
            mark.get(i).setTag(i);
        }

        mMap.setTrafficEnabled(true);

        mMap.setOnMyLocationButtonClickListener(this);
        mMap.setOnMyLocationClickListener(this);
        enableMyLocation();

        float zoom = 12.0f;
        mMap.setOnMarkerClickListener(new GoogleMap.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker) {
                book.setVisibility(View.VISIBLE);
                j = 0;
                for (int i = 0; i < mark.size(); i++){
                    if (mark.get(i).getTitle().equals(marker.getTitle())){
                        j = i;
                        break;
                    }
                }
                return false;
            }
        });
        mMap.animateCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(	55.953251, -3.188267),zoom));
    }

    /**
     * Enables the My Location layer if the fine location permission has been granted.
     */
    private void enableMyLocation() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            // Permission to access the location is missing.
            PermissionUtils.requestPermission(this, LOCATION_PERMISSION_REQUEST_CODE,
                    Manifest.permission.ACCESS_FINE_LOCATION, true);
        } else if (mMap != null) {
            // Access to the location has been granted to the app.
            mMap.setMyLocationEnabled(true);
        }
    }

    @Override
    public boolean onMyLocationButtonClick() {
        Toast.makeText(this, "MyLocation button clicked", Toast.LENGTH_SHORT).show();
        // Return false so that we don't consume the event and the default behavior still occurs
        // (the camera animates to the user's current position).
        return false;
    }

    @Override
    public void onMyLocationClick(@NonNull Location location) {
        Toast.makeText(this, "Current location:\n" + location, Toast.LENGTH_LONG).show();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        if (requestCode != LOCATION_PERMISSION_REQUEST_CODE) {
            return;
        }

        if (PermissionUtils.isPermissionGranted(permissions, grantResults,
                Manifest.permission.ACCESS_FINE_LOCATION)) {
            // Enable the my location layer if the permission has been granted.
            enableMyLocation();
        } else {
            // Display the missing permission error dialog when the fragments resume.
            mPermissionDenied = true;
        }
    }

    @Override
    protected void onResumeFragments() {
        super.onResumeFragments();
        if (mPermissionDenied) {
            // Permission was not granted, display error dialog.
            showMissingPermissionError();
            mPermissionDenied = false;
        }
    }

    /**
     * Displays a dialog with error message explaining that the location permission is missing.
     */
    private void showMissingPermissionError() {
        PermissionUtils.PermissionDeniedDialog
                .newInstance(true).show(getSupportFragmentManager(), "dialog");
    }

}