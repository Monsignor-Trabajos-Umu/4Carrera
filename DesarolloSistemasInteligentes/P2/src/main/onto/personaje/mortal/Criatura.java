package personaje.mortal;


import enumerados.EnumPersonaje;

public class Criatura extends Mortal{

    public Criatura(String nombre) {
        super(nombre);
    }

    public Criatura(EnumPersonaje nombre) {
        super(nombre);
    }
}
