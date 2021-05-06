package preDrools;

import org.dmg.pmml.pmml_4_2.descr.True;

public class Objetivo {

    //TODO usarlo para generalizar en drools
    private String protagonista;
    private String accion;
    private String objetivo;

    public Objetivo(String protagonista, String accion, String objetivo) {
        this.protagonista = protagonista;
        this.accion = accion;
        this.objetivo = objetivo;

    }

    public String getProtagonista() {
        return protagonista;
    }

    public void setProtagonista(String protagonista) {
        this.protagonista = protagonista;
    }

    public String getAccion() {
        return accion;
    }

    public void setAccion(String accion) {
        this.accion = accion;
    }

    public String getObjetivo() {
        return objetivo;
    }

    public void setObjetivo(String objetivo) {
        this.objetivo = objetivo;
    }

    @Override
    public String toString() {
        return "Objetivo{" +
                "protagonista='" + protagonista + '\'' +
                ", accion='" + accion + '\'' +
                ", objetivo='" + objetivo + '\'' +
                '}';
    }

    public Boolean truePrint(String str){
        System.out.println(str);
        return true;
    }
}
