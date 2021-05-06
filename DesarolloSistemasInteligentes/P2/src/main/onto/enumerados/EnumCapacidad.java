package enumerados;

public enum EnumCapacidad {

    INVISIBILIDAD("Invisibilidad"), PETRIFICAR("Petrificar"), REFLEJO("Reflejo"),
    VOLAR("Vuelo"), NINGUNA("Ninguna"), RESISTENCIA("Resistencia"),
    FUERZA("Fuerza"), AFILADO("Afilado"), FUEGO("Fuego");

    private final String nombreCapacidad;


    EnumCapacidad(String nombre) {
        this.nombreCapacidad = nombre;
    }


    public String getNombreCapacidad() {
        return nombreCapacidad;
    }

    @Override
    public String toString() {
        return this.nombreCapacidad;
    }

}
