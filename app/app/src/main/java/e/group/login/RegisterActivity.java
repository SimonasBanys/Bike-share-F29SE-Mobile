package e.group.login;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import java.sql.*;

import org.json.JSONException;
import org.json.JSONObject;

public class RegisterActivity extends AppCompatActivity {
    private static final String KEY_STATUS = "status";
    private static final String KEY_MESSAGE = "message";
    private static final String KEY_FIRST_NAME = "first_name";
    private static final String KEY_LAST_NAME = "last_name";
    private static final String KEY_USERNAME = "username";
    private static final String KEY_PASSWORD = "password";
    private static final String KEY_EMAIL = "email";
    private static final String KEY_DOB = "DoB";
    private static final String KEY_EMPTY = "";
    private EditText etUserName;
    private EditText etPassword;
    private EditText etConfirmPassword;
    private EditText etFirstName;
    private EditText etLastName;
    private EditText etEmail;
    private EditText etDoB;
    private String userName;
    private String password;
    private String confirmPassword;
    private String firstName;
    private String lastName;
    private String email;
    private String DoB;

    private ProgressDialog pDialog;
    private static final String register_url = "http://www2.macs.hw.ac.uk/~sb93/register.php";
    private SessionHandler session;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        session = new SessionHandler(getApplicationContext());
        setContentView(R.layout.activity_register);

        etUserName = findViewById(R.id.etUsername);
        etPassword = findViewById(R.id.etPassword);
        etConfirmPassword = findViewById(R.id.etConfirmPassword);
        etFirstName = findViewById(R.id.etFirstName);
        etLastName = findViewById(R.id.etLastName);
        etEmail = findViewById(R.id.etEmail);
        etDoB = findViewById(R.id.etDoB);

        Button login = findViewById(R.id.btnRegisterLogin);
        Button register = findViewById(R.id.btnRegister);

        //Launch Login screen when Login Button is clicked
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(RegisterActivity.this, LoginActivity.class);
                startActivity(i);
                finish();
            }
        });

        register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Retrieve the data entered in the edit texts
                userName = etUserName.getText().toString().toLowerCase().trim();
                password = etPassword.getText().toString().trim();
                confirmPassword = etConfirmPassword.getText().toString().trim();
                firstName = etFirstName.getText().toString().trim();
                lastName = etLastName.getText().toString().trim();
                email = etEmail.getText().toString().trim();
                DoB = etDoB.getText().toString().trim();

                if (validateInputs()) {
                    registerUser();
                }

            }
        });

    }

    /**
     * Display Progress bar while registering
     */
    private void displayLoader() {
        pDialog = new ProgressDialog(RegisterActivity.this);
        pDialog.setMessage("Signing Up.. Please wait...");
        pDialog.setIndeterminate(false);
        pDialog.setCancelable(false);
        pDialog.show();

    }

    /**
     * Launch Dashboard Activity on Successful Sign Up
     */
    private void loadMaps() {
        Intent i = new Intent(getApplicationContext(), MapsActivity.class);
        startActivity(i);
        finish();

    }

    private void registerUser() {
        displayLoader();
        JSONObject request = new JSONObject();
        Connection con = null;
        int status = 0;

        try {
            //Populate the request parameters
            request.put(KEY_USERNAME, userName);
            request.put(KEY_PASSWORD, password);
            request.put(KEY_FIRST_NAME, firstName);
            request.put(KEY_LAST_NAME, lastName);
            request.put(KEY_EMAIL, email);
            request.put(KEY_DOB, DoB);
        } catch (JSONException e) {
            e.printStackTrace();

        }
        /*try{
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection("jdbc:mysql://mysql-server-1.macs.hw.ac.uk/rh49", "rh49", "e8FpS0qItsvAFLz4");
            PreparedStatement stat = con.prepareStatement("INSERT INTO UserInfo(username, firstName, lastName, password, email, DoB) VALUES (?,?,?,?,?)");
            stat.setString(1, userName);
            stat.setString(2, password);
            stat.setString(3, firstName);
            stat.setString(4, lastName);
            stat.setString(5, email);
            stat.setString(6, DoB);
            status = stat.executeUpdate();
        } catch (Exception e){
            pDialog.dismiss();
            e.printStackTrace();
            Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_LONG).show();
        } finally {
            try {
                if (con != null){
                    pDialog.dismiss();
                    con.close();
                }
            } catch (Exception e){
                pDialog.dismiss();
                e.printStackTrace();
                Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_LONG).show();
            }
        }
        if (status != 0){
            pDialog.dismiss();
            loadMaps();
        }*/
        JsonObjectRequest jsArrayRequest = new JsonObjectRequest
                (Request.Method.POST, register_url, request, new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        pDialog.dismiss();
                        try {
                            //Check if user got registered successfully
                            if (response.getInt(KEY_STATUS) == 0) {
                                //Set the user session
                                Toast.makeText(getApplicationContext(), "shit fuken works", Toast.LENGTH_LONG).show();
                                session.loginUser(userName,firstName);
                                loadMaps();

                            }else if(response.getInt(KEY_STATUS) == 1){
                                //Display error message if username already exists
                                etUserName.setError("Username already taken!");
                                etUserName.requestFocus();

                            }else{
                                Toast.makeText(getApplicationContext(),
                                        response.getString(KEY_MESSAGE), Toast.LENGTH_SHORT).show();

                            }
                        } catch (JSONException e) {
                            e.printStackTrace();

                        }
                    }
                }, new Response.ErrorListener() {

                    @Override
                    public void onErrorResponse(VolleyError error) {
                        pDialog.dismiss();

                        //Display error message whenever an error occurs
                        Toast.makeText(getApplicationContext(),
                                error.getMessage(), Toast.LENGTH_SHORT).show();

                    }
                });

        // Access the RequestQueue through your singleton class.
        MySingleton.getInstance(this).addToRequestQueue(jsArrayRequest);

    }

    /**
     * Validates inputs and shows error if any
     * @return
     */
    private boolean validateInputs() {
        if (KEY_EMPTY.equals(firstName)) {
            etFirstName.setError("First Name cannot be empty");
            etFirstName.requestFocus();
            return false;

        }
        if (KEY_EMPTY.equals(lastName)){
            etLastName.setError("Last Name cannot be empty");
            etLastName.requestFocus();
            return false;
        }
        if (KEY_EMPTY.equals(userName)) {
            etUserName.setError("Username cannot be empty");
            etUserName.requestFocus();
            return false;
        }
        if (KEY_EMPTY.equals(password)) {
            etPassword.setError("Password cannot be empty");
            etPassword.requestFocus();
            return false;
        }

        if (KEY_EMPTY.equals(confirmPassword)) {
            etConfirmPassword.setError("Confirm Password cannot be empty");
            etConfirmPassword.requestFocus();
            return false;
        }
        if (!password.equals(confirmPassword)) {
            etConfirmPassword.setError("Password and Confirm Password does not match");
            etConfirmPassword.requestFocus();
            return false;
        }
        if(KEY_EMPTY.equals(email)){
            etEmail.setError("Email cannot be empty");
            etEmail.requestFocus();
            return false;
        }
        if(KEY_EMPTY.equals(DoB)){
            etEmail.setError("Date of Birth cannot be empty");
            etEmail.requestFocus();
            return false;
        }
        return true;
    }
}
