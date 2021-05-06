package enumerados;

public enum EnumObjeto {

    //Reflejo
    ESCUDOBRONCE("Escudo de Bronce", EnumCapacidad.NINGUNA),
    ESCUDOESPEJO("Escudo Espejo", EnumCapacidad.REFLEJO),
    ESPEJOMANO("Espejo de Mano", EnumCapacidad.REFLEJO),
    EGIDA("Egida", EnumCapacidad.REFLEJO),
    //Volar
    ALASROTAS("Alas rotas", EnumCapacidad.NINGUNA),
    ALAS("Alas", EnumCapacidad.VOLAR),
    SANDALIASALADAS("Sandalias Aladas", EnumCapacidad.VOLAR),
    CONJUROVUELO("Conjuro de Vuelo", EnumCapacidad.VOLAR),
    //Afilado
    HOZACERO("Hoz de Acero", EnumCapacidad.AFILADO),
    CUERNODEMINOTAURO("Cuerno del Minotauro", EnumCapacidad.AFILADO),
    ESPADATESEO("Espada de Teseo", EnumCapacidad.AFILADO),
    //Invisibilidad
    CASCOHADES("Casco de Hades", EnumCapacidad.INVISIBILIDAD),
    ANILLOINVI("Anillo de Invisibilidad", EnumCapacidad.INVISIBILIDAD),
    //Petrificar
    CABEZAMEDUSA("Cabeza de Medusa", EnumCapacidad.PETRIFICAR),
    //Resitencia
    ZURRONMAGICO("Zurron Magico", EnumCapacidad.RESISTENCIA),
    PIELLEONDENEMEA("Piel del leon de Nemea", EnumCapacidad.RESISTENCIA),
    CAJAADAMANTO("Caja de Adamanto", EnumCapacidad.RESISTENCIA),
    //Fuego
    ARMACANDENTE("Arma Candente", EnumCapacidad.FUEGO),
    //Ninguna
    OJOGRAYAS("Ojo de las Grayas", EnumCapacidad.NINGUNA),
    ADAMANTO("Adamantium", EnumCapacidad.NINGUNA),
    HILODEARIADNA("Hilo de Ariadna", EnumCapacidad.NINGUNA),
    CABEZACETO("Cabeza de Ceto", EnumCapacidad.NINGUNA);

    private final String nombreObjeto;
    private final EnumCapacidad capacidad;

    EnumObjeto(String nombre, EnumCapacidad capacidad) {
        this.nombreObjeto = nombre;
        this.capacidad = capacidad;
    }

    public EnumCapacidad getCapacidad() {
        return capacidad;
    }

    public String getNombreObjeto() {
        return nombreObjeto;
    }

    @Override
    public String toString() {
        return this.nombreObjeto;
    }


}
