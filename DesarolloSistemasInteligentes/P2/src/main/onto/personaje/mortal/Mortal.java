package personaje.mortal;


import enumerados.EnumPersonaje;
import personaje.PersonajeMitologico;

public abstract class Mortal extends PersonajeMitologico {
    public Mortal(String nombre) {
        super(nombre);
    }

    public Mortal(EnumPersonaje nombre) {
        super(nombre);
    }
}
