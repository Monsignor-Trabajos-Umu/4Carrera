package preDrools;


import enumerados.EnumObjeto;
import personaje.PersonajeMitologico;

import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;

public class ObjetoParseado {
    public String cadenaCompleta; //Group(0)
    public PersonajeMitologico receptor; //Group(2)
    public Boolean sino; //Group (3)
    public String tieneOApresa; //Group(4)
    public String enojoFavor; //Group (6)
    public PersonajeMitologico emisor;//Group (7)
    public EnumObjeto objeto;

    public ObjetoParseado(Matcher matcher, Map<String, PersonajeMitologico> personajes, Map<String, EnumObjeto> objetos) {

        this.cadenaCompleta = matcher.group(0);
        this.receptor = personajes.get(matcher.group(2));
        this.sino = (matcher.group(3) == null); //Group (3)
        this.tieneOApresa = matcher.group(4);
        this.enojoFavor = matcher.group(6);
        String objetoEmisor = matcher.group(7);
        if (tieneOApresa.equals("tiene") && enojoFavor == null) {
            this.objeto = objetos.get(objetoEmisor);
            this.emisor = null;
        } else {
            this.emisor = personajes.get(objetoEmisor);
            this.objeto = null;
        }


    }

    public Boolean tipoObjeto() {
        return this.objeto != null;
    }

    public Boolean tipoEnojoFavor() {
        return this.enojoFavor != null;
    }

    public Boolean tipoFavor() {
        return this.enojoFavor.equals("favor");
    }

    public Boolean tipoApresa() {
        //System.out.println(this);
        return this.tieneOApresa.equals("apresa");
    }

    @Override
    public String toString() {
        return "ObjetoParseado{" +
                "cadenaCompleta='" + cadenaCompleta + '\'' +
                ", receptor=" + receptor +
                ", sino=" + sino +
                ", tieneOApresa='" + tieneOApresa + '\'' +
                ", enojoFavor='" + enojoFavor + '\'' +
                ", emisor=" + emisor +
                ", objeto=" + objeto +
                '}';
    }
}
