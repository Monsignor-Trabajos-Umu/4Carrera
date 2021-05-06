package enumerados;

public enum EnumPersonaje {
    ZEUS("Zeus"), POSEIDON("Poseidon"), HADES("Hades"), ATENEA("Atenea"), GRAYAS("Grayas"), HERMES("Hermes"),
    DORIS("Doris"), NEREIDAS("Nereidas"), MEDUSA("Medusa"), CETO("Ceto"), PEGASO("Pegaso"), PERSEO("Perseo"),
    ANDROMEDA("Andromeda"), CASIOPEA("Casiopea"), DANAE("Danae"), HEFESTO("Hefesto"), NINFAS("Ninfas"),
    MINOS("Minos"), DEDALO("Dedalo"),ICARO("Icaro"),TESEO("Teseo"),MINOTAURO("Minotauro"),ARIADNA("Ariadna"),
    APOLO("Apolo"),HIDRA("Hidra"),HERACLES("Heracles");
    private final String nombre;


    EnumPersonaje(String nombre) {
        this.nombre = nombre;
    }

    @Override
    public String toString() {
        return this.nombre;
    }

    public String getNombre() {
        return nombre;
    }
}
