package preDrools;

import enumerados.EnumObjeto;
import org.apache.commons.lang3.StringUtils;
import personaje.PersonajeMitologico;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Parser {


    Map<String, PersonajeMitologico> personajes;
    Map<String, EnumObjeto> objetos;

    @SuppressWarnings("unused")
    Objetivo objetivo;

    public Parser(Map<String, PersonajeMitologico> personajes, Map<String, EnumObjeto> objetos) {
        this.personajes = personajes;
        this.objetos = objetos;
    }

    private static String readClean(BufferedReader br) throws IOException {
        return StringUtils.stripAccents(br.readLine());
    }

    /*
     * �Puede Perseo liberar a Andr�meda? Condiciones: Perseo tiene el favor de
     * Atenea Perseo tiene el favor de Hermes Perseo tiene el favor de Hades Perseo
     * tiene el favor de Hefesto Casiopea tiene el enojo de Poseid�n
     */

    public Objetivo getObjetivo() {
        return objetivo;
    }

    private void parseObjetivo(String linea) {
        // �Puede Perseo liberar a Andr�meda?
        Pattern patter = Pattern.compile("¿?[^ ]+ ([^ ]+) (liberar a|matar a|apresar a|tener capacidad|tener|morir) ?([^?]*)\\??",
                Pattern.CASE_INSENSITIVE);
        Matcher matcher = patter.matcher(linea);
        if (matcher.find())
            this.objetivo = new Objetivo(matcher.group(1), matcher.group(2), matcher.group(3));

    }

    public List<ObjetoParseado> parseFile(String fileName) throws IOException {

        FileReader fr = new FileReader(fileName, StandardCharsets.UTF_8);
        BufferedReader br = new BufferedReader(fr);

        String line = readClean(br);
        System.out.println("El objetivo es -> " + line);

        // Objetivo
        this.parseObjetivo(line);
        // Condiciones :
        br.readLine();
        // Perseo tiene el favor de Atenea
        Pattern patter = Pattern.compile("(Las )?(\\w+)( no)? ((tiene el) (enojo|favor) de|apresa|tiene) ([^$.]+).?",
                Pattern.CASE_INSENSITIVE);
        LinkedList<ObjetoParseado> objetosParseados = new LinkedList<ObjetoParseado>();
        while ((line = readClean(br)) != null) {
            //System.out.println(line);
            Matcher matcher = patter.matcher(line);
            if (matcher.find())
                objetosParseados.add(new ObjetoParseado(matcher, this.personajes, this.objetos));

        }
        br.close();
        return objetosParseados;
    }
}