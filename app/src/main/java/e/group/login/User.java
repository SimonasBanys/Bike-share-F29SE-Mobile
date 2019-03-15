package e.group.login;

import java.util.Date;

public class User {
    String username;
    String firstName;
    String lastName;
    String email;
    Date DoB;
    String password;

    public User(){}


    public void setUsername(String username) {
        this.username = username;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password){
        this.password = password;
    }


    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setDoB(Date DoB) {
        this.DoB = DoB;
    }

    public String getUsername() {
        return username;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public Date getDoB() {
        return DoB;
    }

    public String getEmail() {
        return email;
    }
}