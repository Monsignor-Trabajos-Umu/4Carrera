package preDrools;

import enumerados.EnumCapacidad;
import enumerados.EnumEstado;
import enumerados.EnumObjeto;
import enumerados.EnumPersonaje;
import personaje.Inmortal;
import personaje.mortal.Criatura;
import personaje.mortal.humano.Heroe;
import personaje.mortal.humano.HombreImportante;
import personaje.mortal.humano.MujerImportante;
import personaje.PersonajeMitologico;

import java.util.*;
import java.util.stream.Collectors;

public class CreadorBase {


    private final List<PersonajeMitologico> Personajes;
    private final List<EnumObjeto> Objetos;


    public CreadorBase() {
        Inmortal Zeus, Poseidon, Hades;
        Inmortal Atenea, Grayas, Hermes, Doris, Nereidas, Hefesto, Ninfas, Apolo;
        Criatura Medusa, Ceto, Minotauro, Hidra;
        Heroe Perseo, Teseo, Heracles;
        MujerImportante Andromeda, Casiopea, Danae, Ariadna;
        HombreImportante Minos, Icaro, Dedalo;

        this.Personajes = new LinkedList<>();
        this.Objetos = new LinkedList<>();


        //Objeccccctos

        Objetos.add(EnumObjeto.ANILLOINVI);
        Objetos.add(EnumObjeto.CASCOHADES);
        Objetos.add(EnumObjeto.ESCUDOBRONCE);
        Objetos.add(EnumObjeto.ESCUDOESPEJO);
        Objetos.add(EnumObjeto.ESPEJOMANO);
        Objetos.add(EnumObjeto.OJOGRAYAS);
        Objetos.add(EnumObjeto.HOZACERO);
        Objetos.add(EnumObjeto.CABEZAMEDUSA);
        Objetos.add(EnumObjeto.SANDALIASALADAS);
        Objetos.add(EnumObjeto.CONJUROVUELO);
        Objetos.add(EnumObjeto.ZURRONMAGICO);
        Objetos.add(EnumObjeto.HILODEARIADNA);
        Objetos.add(EnumObjeto.ESPADATESEO);
        Objetos.add(EnumObjeto.ALASROTAS);
        Objetos.add(EnumObjeto.ALAS);
        Objetos.add(EnumObjeto.CUERNODEMINOTAURO);
        Objetos.add(EnumObjeto.CABEZACETO);
        Objetos.add(EnumObjeto.PIELLEONDENEMEA);
        Objetos.add(EnumObjeto.EGIDA);
        Objetos.add(EnumObjeto.ADAMANTO);
        Objetos.add(EnumObjeto.CAJAADAMANTO);
        Objetos.add(EnumObjeto.ARMACANDENTE);
        //Personajes


        Zeus = new Inmortal(EnumPersonaje.ZEUS);
        Zeus.getObjetos().add(EnumObjeto.EGIDA);
        Zeus.getCapacidades().add(EnumObjeto.EGIDA.getCapacidad());
        Poseidon = new Inmortal(EnumPersonaje.POSEIDON);
        Hades = new Inmortal(EnumPersonaje.HADES);
        Hades.getObjetos().add(EnumObjeto.CASCOHADES);
        Hades.getCapacidades().add(EnumObjeto.CASCOHADES.getCapacidad());


        this.Personajes.add(Zeus);
        this.Personajes.add(Poseidon);
        this.Personajes.add(Hades);


        //Atenea Grayas y su ojo

        Atenea = new Inmortal(EnumPersonaje.ATENEA);
        Atenea.getObjetos().add(EnumObjeto.ESCUDOBRONCE);
        Atenea.getCapacidades().add(EnumObjeto.ESCUDOBRONCE.getCapacidad());

        Grayas = new Inmortal(EnumPersonaje.GRAYAS);
        Grayas.getObjetos().add(EnumObjeto.OJOGRAYAS);
        Grayas.getCapacidades().add(EnumObjeto.OJOGRAYAS.getCapacidad());

        this.Personajes.add(Atenea);
        this.Personajes.add(Grayas);

        //Hermes HozAcero

        Hermes = new Inmortal(EnumPersonaje.HERMES);
        Hermes.getObjetos().add(EnumObjeto.HOZACERO);
        Hermes.getCapacidades().add(EnumObjeto.HOZACERO.getCapacidad());

        Personajes.add(Hermes);


        //Nereidas y doris

        Nereidas = new Inmortal(EnumPersonaje.NEREIDAS);
        Doris = new Inmortal(EnumPersonaje.DORIS);

        this.Personajes.add(Nereidas);
        this.Personajes.add(Doris);

        //Medusa y sus cabeza
        Medusa = new Criatura(EnumPersonaje.MEDUSA);
        Medusa.getObjetos().add(EnumObjeto.CABEZAMEDUSA);
        Medusa.getCapacidades().add(EnumObjeto.CABEZAMEDUSA.getCapacidad());
        Personajes.add(Medusa);


        //Ceto
        Ceto = new Criatura(EnumPersonaje.CETO);
        Poseidon.getApresado().add(Ceto);
        Ceto.setEstado(EnumEstado.PRISIONERO);
        Ceto.getObjetos().add(EnumObjeto.CABEZACETO);
        Ceto.getCapacidades().add(EnumObjeto.CABEZACETO.getCapacidad());
        this.Personajes.add(Ceto);

        // Andromeda y Casiopea
        Andromeda = new MujerImportante(EnumPersonaje.ANDROMEDA);
        Casiopea = new MujerImportante(EnumPersonaje.CASIOPEA);
        this.Personajes.add(Andromeda);
        this.Personajes.add(Casiopea);

        //Danea y Perseo

        Danae = new MujerImportante(EnumPersonaje.DANAE);
        Perseo = new Heroe(EnumPersonaje.PERSEO);
        this.Personajes.add(Danae);
        this.Personajes.add(Perseo);

        //NINFAS zurron y sandalias
        Ninfas = new Inmortal(EnumPersonaje.NINFAS);
        Ninfas.getObjetos().addAll(Arrays.asList(EnumObjeto.ZURRONMAGICO, EnumObjeto.SANDALIASALADAS));
        Ninfas.getCapacidades().addAll(Arrays.asList(EnumObjeto.ZURRONMAGICO.getCapacidad(), EnumObjeto.SANDALIASALADAS.getCapacidad()));
        this.Personajes.add(Ninfas);

        //Hefesto y los espejos
        Hefesto = new Inmortal(EnumPersonaje.HEFESTO);
        // Hefesto no tiene escudo espejo se genera en una regla
        this.Personajes.add(Hefesto);

        Minotauro = new Criatura(EnumPersonaje.MINOTAURO);
        Minotauro.setEstado(EnumEstado.LABERINTO);
        Minotauro.getObjetos().addAll(Arrays.asList(EnumObjeto.CUERNODEMINOTAURO, EnumObjeto.ADAMANTO));
        Minotauro.getCapacidades().addAll(Arrays.asList(EnumObjeto.CUERNODEMINOTAURO.getCapacidad(), EnumObjeto.ADAMANTO.getCapacidad()));
        this.Personajes.add(Minotauro);

        Teseo = new Heroe(EnumPersonaje.TESEO);
        Teseo.getObjetos().add(EnumObjeto.ESPADATESEO);
        Teseo.getCapacidades().add(EnumObjeto.ESPADATESEO.getCapacidad());
        this.Personajes.add(Teseo);

        Ariadna = new MujerImportante(EnumPersonaje.ARIADNA);
        Ariadna.getObjetos().add(EnumObjeto.HILODEARIADNA);
        Ariadna.getCapacidades().add(EnumObjeto.HILODEARIADNA.getCapacidad());
        this.Personajes.add(Ariadna);

        Minos = new HombreImportante(EnumPersonaje.MINOS);
        this.Personajes.add(Minos);

        Icaro = new HombreImportante(EnumPersonaje.ICARO);
        Icaro.getObjetos().add(EnumObjeto.ALASROTAS);
        Icaro.getCapacidades().add(EnumObjeto.ALASROTAS.getCapacidad());
        this.Personajes.add(Icaro);

        Dedalo = new HombreImportante(EnumPersonaje.DEDALO);
        Dedalo.getObjetos().add(EnumObjeto.ALASROTAS);
        Dedalo.getCapacidades().add(EnumObjeto.ALASROTAS.getCapacidad());
        this.Personajes.add(Dedalo);


        Apolo = new Inmortal(EnumPersonaje.APOLO);
        this.Personajes.add(Apolo);

        Heracles = new Heroe(EnumPersonaje.HERACLES);
        Heracles.getObjetos().add(EnumObjeto.PIELLEONDENEMEA);
        Heracles.getCapacidades().add(EnumObjeto.PIELLEONDENEMEA.getCapacidad());
        Heracles.getCapacidades().add(EnumCapacidad.FUERZA);
        Heracles.getFavores().add(Zeus);
        this.Personajes.add(Heracles);

        Hidra = new Criatura(EnumPersonaje.HIDRA);
        this.Personajes.add(Hidra);
    }

    public Map<String, PersonajeMitologico> getPersonajes() {

        return this.Personajes.stream().collect(Collectors.toMap(PersonajeMitologico::getNombre, p -> p));
    }

    public Map<String, EnumObjeto> getObjetos() {

        return this.Objetos.stream().collect(Collectors.toMap(Objects::toString, o -> o));
    }

    public List<EnumCapacidad> getCapacidades() {
        LinkedList<EnumCapacidad> capacidades = new LinkedList<EnumCapacidad>();
        capacidades.add(EnumCapacidad.INVISIBILIDAD);
        capacidades.add(EnumCapacidad.PETRIFICAR);
        capacidades.add(EnumCapacidad.REFLEJO);
        capacidades.add(EnumCapacidad.VOLAR);
        capacidades.add(EnumCapacidad.NINGUNA);
        capacidades.add(EnumCapacidad.RESISTENCIA);
        capacidades.add(EnumCapacidad.AFILADO);
        capacidades.add(EnumCapacidad.FUERZA);
        capacidades.add(EnumCapacidad.FUEGO);
        return capacidades;
    }
}
