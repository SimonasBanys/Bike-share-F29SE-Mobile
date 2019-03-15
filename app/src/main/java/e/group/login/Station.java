package e.group.login;

import com.google.android.gms.maps.model.LatLng;

public class Station {

    private LatLng coord;
    private String label;
    private int inStation;
    private int leftSpace;
    private static final int maxSpace = 20;
    private int booked;

    public Station(double x, double y, String label, int parked, int space){
        this.coord = new LatLng(x, y);
        this.label = label;
        this.inStation = parked;
        this.leftSpace = space;
        this.booked = maxSpace - parked - space;
    }

    public int getSpace(){
        return leftSpace;
    }

    public int getBikes(){
        return inStation;
    }

    public LatLng getCoord(){
        return coord;
    }

    public String getLabel(){
        return label;
    }

    public int getBooked(){
        return booked;
    }

    public boolean bookCycle(){
        if (inStation == 0){
            return false;
        } else if (booked == inStation){
            return false;
        } else if (booked < inStation && inStation > 1){
            inStation--;
            booked++;
            return true;
        } else return false;
    }

    public boolean checkOut(){
        if (inStation > 0){
            inStation--;
            leftSpace++;
            return true;
        }
        else return false;
    }
}
