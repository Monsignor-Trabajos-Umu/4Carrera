package com.sample;

import enumerados.EnumCapacidad;
import enumerados.EnumObjeto;
import org.kie.api.KieServices;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.rule.Agenda;
import personaje.PersonajeMitologico;
import preDrools.*;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * This is a sample class to launch a rule.
 */
public class Main {

    public static void main(String[] args) {


        try {
            // load up the knowledge base
            KieServices ks = KieServices.Factory.get();
            KieContainer kContainer = ks.getKieClasspathContainer();
            KieSession kSession = kContainer.newKieSession("reglas-perseo");
            //KieRuntimeLogger logger = ks.getLoggers().newThreadedFileLogger(kSession, "./session", 1000 );

//Prueba para ver si me va
            CreadorBase creador = new CreadorBase();

            Map<String, PersonajeMitologico> personajes = creador.getPersonajes();
            Map<String, EnumObjeto> objetos = creador.getObjetos();
            List<EnumCapacidad> capacidades = creador.getCapacidades();
            //comentario mio

            Parser p = new Parser(personajes, objetos);

            List<ObjetoParseado> obejtosParseados = p.parseFile(args[0]);
            Objetivo objetivo = p.getObjetivo();
            //System.out.println(objetivo);
            kSession.insert(objetivo);

            for (ObjetoParseado objetoParseado : obejtosParseados) {
                kSession.insert(objetoParseado);
            }
            for (PersonajeMitologico personaje : personajes.values()) {
                kSession.insert(personaje);
            }
            for (EnumObjeto objeto : objetos.values()) {
                kSession.insert(objeto);

            }
            for (EnumCapacidad capacidad : capacidades) {
                kSession.insert(capacidad);
            }

            // Lista con las reglas aplicadas
            ReglasAplicadas list = new ReglasAplicadas();
            kSession.setGlobal( "salida", list );

            Agenda agenda = kSession.getAgenda();
            agenda.getAgendaGroup("construccion").setFocus();
            kSession.fireAllRules();
            agenda.getAgendaGroup("Mito").setFocus();
            kSession.fireAllRules();
            //agenda.getAgendaGroup("Check").setFocus();
            //kSession.fireAllRules();

            //kSession.getAgenda().getAgendaGroup("PrintRaro").setFocus();
            //kSession.fireAllRules();


        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
}
