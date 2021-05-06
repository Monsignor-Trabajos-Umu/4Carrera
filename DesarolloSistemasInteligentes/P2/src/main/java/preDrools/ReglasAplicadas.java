package preDrools;

import java.util.ArrayList;
import java.util.List;


public class ReglasAplicadas extends ArrayList<String> {




    @Override
    public String toString() {
        StringBuilder reglas = new StringBuilder();
        for (String regla : this) {
            reglas.append(regla).append("\n");
        }
        return reglas.toString();
    }
}
