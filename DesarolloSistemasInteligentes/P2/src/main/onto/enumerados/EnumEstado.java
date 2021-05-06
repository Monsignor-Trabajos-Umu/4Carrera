package enumerados;

public enum EnumEstado {
    MUERTO ("Muerto"), PRISIONERO ("Prisionero"),VIVO ("Vivo"), LABERINTO ("Laberinto");

    private String nombre;

    private EnumEstado(String nombre) {
        this.nombre = nombre;
    }

    @Override
    public String toString() {
        return this.nombre;
    }


}
