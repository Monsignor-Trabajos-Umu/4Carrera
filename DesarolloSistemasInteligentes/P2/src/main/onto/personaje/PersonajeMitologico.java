package personaje;

import enumerados.EnumCapacidad;
import enumerados.EnumEstado;
import enumerados.EnumObjeto;
import enumerados.EnumPersonaje;

import java.util.*;
import java.util.stream.Collectors;


public abstract class PersonajeMitologico {

    private final String nombre;

    private EnumEstado estado;
    private List<PersonajeMitologico> apresado; //A quien tiene preso
    private PersonajeMitologico asesino; //El que esta muerto tiene a su asesino
    private PersonajeMitologico salvador; //Quien te libera

    private List<PersonajeMitologico> favores; //lista de quien tienes favor
    private List<PersonajeMitologico> enfadados; //lista de los que has enfadado
    private List<EnumObjeto> objetos;

    private List<EnumCapacidad> capacidades;


    //Construtor

    public PersonajeMitologico(String nombre) {
        this.nombre = nombre;
    }
    public PersonajeMitologico(EnumPersonaje nombre) {
        this.nombre = nombre.toString();

        this.estado = EnumEstado.VIVO;
        this.apresado = new LinkedList<PersonajeMitologico>();
        this.salvador = null;

        this.asesino = null;
        this.favores = new LinkedList<PersonajeMitologico>();
        this.enfadados = new LinkedList<PersonajeMitologico>();
        this.objetos = new LinkedList<EnumObjeto>();
        this.capacidades = new LinkedList<EnumCapacidad>();


    }

    // Getter & Setter

    public String getNombre() {
        return nombre;
    }

    public EnumEstado getEstado() {
        return estado;
    }

    public void setEstado(EnumEstado estado) {
        this.estado = estado;
    }

    public List<PersonajeMitologico> getApresado() {
        return apresado;
    }

    public void setApresado(List<PersonajeMitologico> apresado) {
        this.apresado = apresado;
    }

    public PersonajeMitologico getSalvador() {
        return salvador;
    }

    public void setSalvador(PersonajeMitologico salvador) {
        this.salvador = salvador;
    }

    public PersonajeMitologico getAsesino() {
        return asesino;
    }

    public void setAsesino(PersonajeMitologico asesino) {
        this.asesino = asesino;
    }

    public List<PersonajeMitologico> getFavores() {
        return favores;
    }

    public void setFavores(List<PersonajeMitologico> favores) {
        this.favores = favores;
    }

    public List<PersonajeMitologico> getEnfadados() {
        return enfadados;
    }

    public void setEnfadados(List<PersonajeMitologico> enfadados) {
        this.enfadados = enfadados;
    }


    public List<EnumObjeto> getObjetos() {
        return objetos;
    }

    public List<EnumObjeto> getObjetos(String cadena) {
        System.out.println(cadena + " -> " + this.objetos.toString());
        return objetos;
    }

    public void setObjetos(List<EnumObjeto> objetos) {
        this.objetos = objetos;
    }

    public List<EnumCapacidad> getCapacidades() {
        return capacidades;
    }

    public void setCapacidades(List<EnumCapacidad> capacidades) {
        this.capacidades = capacidades;
    }
//Funciones contruccion NO SE USAN EN DROOLS


    @Override
    public String toString() {
        return "P{" +
                "nombre='" + nombre + '\'' +
                ", enumEstado=" + estado +
                ", apresado=" + apresado +
                ", favores= " + favores.stream().map(PersonajeMitologico::getNombre).collect(Collectors.joining(",")) +
                ", enfadados=" + enfadados.stream().map(PersonajeMitologico::getNombre).collect(Collectors.joining(","))+
                ", objetos=" + objetos +
                ", capacidades=" + capacidades.stream().map(EnumCapacidad::getNombreCapacidad).collect(Collectors.joining(",")) +
                " }";
    }
}

