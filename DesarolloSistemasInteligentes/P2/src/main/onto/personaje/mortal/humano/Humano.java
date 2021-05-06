package personaje.mortal.humano;

import enumerados.EnumPersonaje;
import personaje.mortal.Mortal;

public abstract class Humano extends Mortal {
    public Humano(String nombre) {
        super(nombre);
    }

    public Humano(EnumPersonaje nombre) {
        super(nombre);
    }
}
