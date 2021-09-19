//
// Created by edymola on 19/03/18.
//

#include "Directa.h"

bool direccta::__getcadena() {

    std::string cadenalarga;
    std::string buffer;
    std::string cadena_temp;
    int contador_vocales = 0;
    int contador_consonantes = 0;
    int posicion_ultimaletra_cadenalarga_buffer = 0;
    int posicion_ultimaletra_cadenalarga = 0;

    for (int i = 0; i < cadena_principal.length(); ++i) {


        char letra = cadena_principal[i];
        cadena_temp += letra;
        //std::cout << std::endl;

        if (voval_or_consonat(letra)) {
            // Es vocal

            contador_vocales = contador_vocales + 1;

            if (contador_consonantes < 3) {
                //Error
                contador_consonantes = 0;
                contador_vocales = 0;
                if ((not buffer.empty()) && buffer.length() > cadenalarga.length()) {
                    cadenalarga = buffer;
                    posicion_ultimaletra_cadenalarga = posicion_ultimaletra_cadenalarga_buffer;
                }
                buffer.clear();
                cadena_temp.clear();
            } else {
                //cons = 3

                if (contador_vocales > 2) {
                    //Error
                    contador_consonantes = 0;
                    contador_vocales = 0;
                    if ((not buffer.empty()) && buffer.length() > cadenalarga.length()) {
                        cadenalarga = buffer;
                        posicion_ultimaletra_cadenalarga = posicion_ultimaletra_cadenalarga_buffer;
                    }
                    buffer.clear();
                    cadena_temp.clear();
                } else if (contador_vocales == 2) {
                    contador_consonantes = 0;
                    contador_vocales = 0;
                    buffer += cadena_temp;
                    cadena_temp.clear();
                    posicion_ultimaletra_cadenalarga_buffer = i;
                } else if (contador_vocales < 2) {
                    //Nada
                }


            }


        } else {

            contador_consonantes = contador_consonantes + 1;
        if (contador_vocales==0) {
            if (contador_consonantes > 3) {
                //Error
                contador_consonantes = 3;
                contador_vocales = 0;
                if ((not buffer.empty()) && buffer.length() > cadenalarga.length()) {
                    cadenalarga = buffer;
                    posicion_ultimaletra_cadenalarga = posicion_ultimaletra_cadenalarga_buffer;
                }
                buffer.clear();
                //Convierto la cadena de 4 consonantes en 3
                std::string temp(cadena_temp.begin() + 1, cadena_temp.end());
                cadena_temp = temp;
            } else if (contador_consonantes <= 3) {
                //Nada
            }
        } else if (contador_vocales != 0){
            //Error
            contador_consonantes = 1;
            contador_vocales = 0;
            if ((not buffer.empty()) && buffer.length() > cadenalarga.length()) {
                cadenalarga = buffer;
                posicion_ultimaletra_cadenalarga = posicion_ultimaletra_cadenalarga_buffer;
            }
            buffer.clear();
            //Limpio la cadena temporal y añado el ultimo char
            cadena_temp.clear();
            cadena_temp+=letra;

        }
        }


        /*
         * if (not voval_or_consonat(letra)) {
             contador_consonantes = contador_consonantes + 1;
             cadena_temp += letra;
         } else {
             if (contador_consonantes < 3) {


                 if (not buffer.empty()) {
                     if (buffer.length() >= 5 && buffer.length() > cadenalarga.length()) {
                         cadenalarga = buffer;
                         posicion_ultimaletra_cadenalarga = i - cadena_temp.length();
                     }
                     //Vaciamos el buffer
                     buffer = "";
                 }
                 cadena_temp = "";
                 contador_consonantes = 0;
                 contador_vocales = 0;


             }
         }

         if (contador_consonantes == 4) {

             contador_consonantes = 3;
             std::string temp(cadena_temp.begin() + 1, cadena_temp.end());

             cadena_temp = temp;
             //cadena_temp.clear();
             //Si el buffer no esta vacio comprobamos si es mayor que la cadenalargar
             if (not buffer.empty() && buffer.length() > cadenalarga.length()) {
                 cadenalarga = buffer;
                 posicion_ultimaletra_cadenalarga = i - cadena_temp.length();
             }
             //Vaciamos la primera letra del buffer
             buffer = "";

         } else {

             if (contador_consonantes == 3) {

                 if (voval_or_consonat(letra)) {
                     contador_vocales++;
                     cadena_temp += letra;
                     if (contador_vocales == 2) {
                         contador_vocales = 0;
                         contador_consonantes = 0;
                         buffer += cadena_temp;
                         cadena_temp.clear();
                     }


                     }


                 } else {
                     if (contador_vocales = 1) {
                         contador_consonantes = 1;
                         contador_vocales = 0;
                         if (not buffer.empty() && buffer.length() > cadenalarga.length()) {
                             cadenalarga = buffer;
                             posicion_ultimaletra_cadenalarga = i - cadena_temp.length();


                     }
                         buffer="";
                         cadena_temp = "";
                 }
             }
         }*/

        /*
        std::cout << "Lectra actual " << letra << " posicion " << i << std::endl;
        std::cout << "Vocal ? " << voval_or_consonat(letra) << std::endl;
        std::cout << "Cadenalarga  " << cadenalarga << std::endl;
        std::cout << "Cadenalarga posicion " << posicion_ultimaletra_cadenalarga << std::endl;
        std::cout << "buffer actual " << buffer << std::endl;
        std::cout << "cadena_temp actual " << cadena_temp << std::endl;
        std::cout << "contador_vocales " << contador_vocales << std::endl;
        std::cout << "contador_consonantes  " << contador_consonantes << std::endl;*/
    }
    //Ultima comprobacion
    if (not buffer.empty() && buffer.length() > cadenalarga.length()) {
        cadenalarga = buffer;
        posicion_ultimaletra_cadenalarga = static_cast<int>(cadena_principal.length() - cadena_temp.length());
    }

    this->resultado_tupla_posicion = std::make_tuple(cadenalarga, posicion_ultimaletra_cadenalarga);
    return (not cadenalarga.empty());
}
/*

if (contador_consonantes == 3) {

    if (voval_or_consonat(letra) == 1) {
        contador_vocales++;
        cadena_temp += letra;
    };
    if (contador_vocales == 2) {
        contador_vocales = 0;
        contador_consonantes = 0;
        buffer += cadena_temp;
    }

}

if (contador_vocales > 2) {
    contador_vocales = 0;
    cadena_temp = "";
    //Si el buffer no esta vacio comprobamos si es mayor que la cadenalargar
    if (not buffer.empty() && buffer.length() > cadenalarga.length()) {
        cadenalarga = buffer;
    }
    //Vaciamos el buffer
    buffer = "";
}
 */







