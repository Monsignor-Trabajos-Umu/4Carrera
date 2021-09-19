#include <iostream>

//
// Created by edymola on 14/04/18.
//
#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>
#include <random>
#include <chrono>
using namespace std;

string random_string(int tanamo){
    // obtain a seed from the system clock:


    auto randchar = []() -> char
        {
            unsigned seed1 = std::chrono::system_clock::now().time_since_epoch().count();
            minstd_rand0 generator (seed1);
            const char charset[] =
                    "abcdefghijklmnopqrstuvwxyz";
            const size_t max_index = (sizeof(charset) - 1);
            return charset[ generator() % max_index ];
        };
        std::string str(tanamo,0);
        generate_n( str.begin(), tanamo, randchar );
        return str;
    }




struct resultado {
    string cadena_actual="";
    string cadena_resultado ="";
    int posicion_inicial = 0;
    int posicion_final= 0;

} ;

vector<resultado> dividide_3(string cadena) {

    int temp = (int(floor(cadena.length() / 2)));
    // cout << temp << " longitud total " << cadena.length() << endl;
    std::vector<resultado> lista_resultados;


    /* [begin    begin+temp]  [begin+temp+1     end]*/
    resultado temp_r;
    temp_r.cadena_actual  = string(cadena.begin(), cadena.begin() + temp);

    lista_resultados.push_back(temp_r);

    temp_r.cadena_actual = string(cadena.begin() + temp - 4, cadena.begin() + temp + 1 + 3);

    lista_resultados.push_back(temp_r);

    temp_r.cadena_actual = string(cadena.begin() + temp, cadena.end());

    lista_resultados.push_back(temp_r);


    return lista_resultados;
}

resultado juntar(string cadena_total_actual,resultado izquierda, resultado centro,resultado derecha) {
    //string izquierda, vector<string> resultados, vector<int> inicio, vector<int> final
    resultado resultadofinal;
    resultadofinal.cadena_actual=cadena_total_actual;

    // cout << "Juntar" << endl;

    int accareo_para_cadena_2 = static_cast<int>(izquierda.cadena_actual.length() - 4);


    int accareo_para_cadena_3 = izquierda.cadena_actual.length();
    
    int nuevo_resultado_in_izquierda = izquierda.posicion_inicial;
    int nuevo_resultado_fin_izquierda = izquierda.posicion_final;

    int nuevo_resultado_in_centro = centro.posicion_inicial + accareo_para_cadena_2;
    int nuevo_resultado_fin_centro = centro.posicion_final + accareo_para_cadena_2;

    int nuevo_resultado_in_derecha = derecha.posicion_inicial + accareo_para_cadena_3;
    int nuevo_resultado_fin_derecha = derecha.posicion_final + accareo_para_cadena_3;
    
    bool izquierda_toca_centro   = (nuevo_resultado_in_centro-nuevo_resultado_fin_izquierda)==1;
    bool centro_toca_derecha     = (nuevo_resultado_in_derecha-nuevo_resultado_fin_centro)==1;
    bool izquierda_toca_derecha  = (nuevo_resultado_in_derecha-nuevo_resultado_fin_izquierda)==1;
    //cout << nuevo_resultado_in_izquierda << " " << izquierda.cadena_resultado <<" "<< nuevo_resultado_fin_izquierda << endl;
    //cout << nuevo_resultado_in_centro << " " << centro.cadena_resultado <<" "<< nuevo_resultado_fin_centro << endl;
    //cout << nuevo_resultado_in_derecha << " " << derecha.cadena_resultado <<" "<< nuevo_resultado_fin_derecha << endl;


    if (izquierda.cadena_resultado.length() == 0 && centro.cadena_resultado.length() == 0 && derecha.cadena_resultado.length() == 0) {
        // 0,0,0
        //cout << "No hay solucion " << endl;
        resultadofinal.cadena_resultado = "";
        resultadofinal.posicion_inicial = 0;
        resultadofinal.posicion_final = 0;
        return resultadofinal;
    } else {
        if (izquierda.cadena_resultado.length() == 0 && centro.cadena_resultado.length() == 0 && derecha.cadena_resultado.length() !=0) {
            // 0,0,X

            resultadofinal.cadena_resultado = derecha.cadena_resultado;
            resultadofinal.posicion_inicial = nuevo_resultado_in_derecha;
            resultadofinal.posicion_final = nuevo_resultado_fin_derecha;
            return resultadofinal;


        } else if (izquierda.cadena_resultado.length() == 0 && centro.cadena_resultado.length() != 0 && derecha.cadena_resultado.length() == 0) {
            //0,X,0
            resultadofinal.cadena_resultado = centro.cadena_resultado;
            resultadofinal.posicion_inicial = nuevo_resultado_in_centro;
            resultadofinal.posicion_final = nuevo_resultado_fin_centro;
            return resultadofinal;
        } else if (izquierda.cadena_resultado.length() != 0 && centro.cadena_resultado.length() == 0 && derecha.cadena_resultado.length() == 0) {
            //X,0,0
            resultadofinal.cadena_resultado = izquierda.cadena_resultado;
            resultadofinal.posicion_inicial = nuevo_resultado_in_izquierda;
            resultadofinal.posicion_final = nuevo_resultado_fin_izquierda;
            return resultadofinal;

        } else if (izquierda.cadena_resultado.length() != 0 && centro.cadena_resultado.length() != 0 && derecha.cadena_resultado.length() == 0) {
            //XX,0

            if (izquierda_toca_centro) {

                resultadofinal.cadena_resultado = izquierda.cadena_resultado + centro.cadena_resultado;
                resultadofinal.posicion_inicial = nuevo_resultado_in_izquierda;
                resultadofinal.posicion_final = nuevo_resultado_fin_centro;
                return resultadofinal;

                //return izquierda.cadena_resultado + centro.cadena_resultado;
            } else {
                if (izquierda.cadena_resultado.length() >= centro.cadena_resultado.length()) {
                    resultadofinal.cadena_resultado = izquierda.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_izquierda;
                    resultadofinal.posicion_final = nuevo_resultado_fin_izquierda;
                    return resultadofinal;
                } else {
                    resultadofinal.cadena_resultado = centro.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_centro;
                    resultadofinal.posicion_final = nuevo_resultado_fin_centro;
                    return resultadofinal;
                }

            }


        } else if (izquierda.cadena_resultado.length() != 0 && centro.cadena_resultado.length() == 0 && derecha.cadena_resultado.length() != 0) {
            //X,0,X

            if (izquierda_toca_derecha) {

                resultadofinal.cadena_resultado = izquierda.cadena_resultado + derecha.cadena_resultado;
                resultadofinal.posicion_inicial = nuevo_resultado_in_izquierda;
                resultadofinal.posicion_final = nuevo_resultado_fin_derecha;
                return resultadofinal;
                // return izquierda.cadena_resultado + derecha.cadena_resultado;
            } else {
                if (izquierda.cadena_resultado.length() >= derecha.cadena_resultado.length()) {

                    resultadofinal.cadena_resultado = izquierda.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_izquierda;
                    resultadofinal.posicion_final = nuevo_resultado_fin_izquierda;
                    return resultadofinal;
                } else {
                    resultadofinal.cadena_resultado = derecha.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_derecha;
                    resultadofinal.posicion_final = nuevo_resultado_fin_derecha;
                    return resultadofinal;
                }

            }
        } else if (izquierda.cadena_resultado.length() == 0 && centro.cadena_resultado.length() != 0 && derecha.cadena_resultado.length() != 0) {
            //0,X,X

            if (centro_toca_derecha) {
                resultadofinal.cadena_resultado = centro.cadena_resultado + derecha.cadena_resultado;
                resultadofinal.posicion_inicial = nuevo_resultado_in_centro;
                resultadofinal.posicion_final = nuevo_resultado_fin_derecha;
                return resultadofinal;
                // return centro.cadena_resultado + derecha.cadena_resultado;
            } else {
                if (centro.cadena_resultado.length() >= derecha.cadena_resultado.length()) {

                    resultadofinal.cadena_resultado = centro.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_centro;
                    resultadofinal.posicion_final = nuevo_resultado_fin_centro;
                    return resultadofinal;
                    // return centro.cadena_resultado;
                } else {
                    resultadofinal.cadena_resultado = derecha.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_derecha;
                    resultadofinal.posicion_final = nuevo_resultado_fin_derecha;
                    return resultadofinal;
                    // return derecha.cadena_resultado;
                }

            }
        } else {
            //X,Y,Z
            string temp = "";
            if (izquierda_toca_centro) {
                //XY,Z
                temp = izquierda.cadena_resultado + centro.cadena_resultado;
                if (centro_toca_derecha) {
                    //XYZ
                    resultadofinal.cadena_resultado = izquierda.cadena_resultado + centro.cadena_resultado + derecha.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_izquierda;
                    resultadofinal.posicion_final = nuevo_resultado_fin_derecha;
                    return resultadofinal;

                    // return temp+derecha.cadena_resultado;
                } else {
                    if (temp.length() >= derecha.cadena_resultado.length()) {
                        // XY
                        resultadofinal.cadena_resultado = temp; //izquierda.cadena_resultado + centro.cadena_resultado;
                        resultadofinal.posicion_inicial = nuevo_resultado_in_izquierda;
                        resultadofinal.posicion_final = nuevo_resultado_fin_centro;
                        return resultadofinal;
                        // return temp;

                    } else {
                        //Z
                        resultadofinal.cadena_resultado = derecha.cadena_resultado;
                        resultadofinal.posicion_inicial = nuevo_resultado_in_derecha;
                        resultadofinal.posicion_final = nuevo_resultado_fin_derecha;
                        return resultadofinal;
                        // return derecha.cadena_resultado;
                    }

                }
            } else if (centro_toca_derecha) {
                //X,YZ
                temp = centro.cadena_resultado + derecha.cadena_resultado;
                /* imposible porque se hubiera comprobado en el caso anterior
                if (nuevo_resultado_fin_izquierda==nuevo_resultado_in_centro){
                    //XYZ
                    return temp+derecha.cadena_resultado;*/
                {
                    if (temp.length() > izquierda.cadena_resultado.length()) {
                        // YZ
                        resultadofinal.cadena_resultado = temp;  //centro.cadena_resultado + derecha.cadena_resultado;
                        resultadofinal.posicion_inicial = nuevo_resultado_in_centro;
                        resultadofinal.posicion_final = nuevo_resultado_fin_derecha;
                        return resultadofinal;
                        // return temp;

                    } else {
                        //X
                        resultadofinal.cadena_resultado = izquierda.cadena_resultado;
                        resultadofinal.posicion_inicial = nuevo_resultado_in_izquierda;
                        resultadofinal.posicion_final = nuevo_resultado_fin_izquierda;
                        return resultadofinal;
                        // return izquierda.cadena_resultado;
                    }

                }

            }
                // else if(izquierda_toca_derecha) imposible porque hay algo siempre enmedio
                // cccaaccaa se comprueba en la linea 117
            else {
                // X / Y / Z
                if (izquierda.cadena_resultado.length() >= centro.cadena_resultado.length() &&
                    izquierda.cadena_resultado.length() >= derecha.cadena_resultado.length()) {

                    resultadofinal.cadena_resultado = izquierda.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_izquierda;
                    resultadofinal.posicion_final = nuevo_resultado_fin_izquierda;
                    return resultadofinal;
                    //return izquierda.cadena_resultado;
                } else if (centro.cadena_resultado.length() > izquierda.cadena_resultado.length() &&
                           centro.cadena_resultado.length() >= derecha.cadena_resultado.length()) {

                    resultadofinal.cadena_resultado = centro.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_centro;
                    resultadofinal.posicion_final = nuevo_resultado_fin_centro;
                    return resultadofinal;
                    //return centro.cadena_resultado;
                } else {
                    resultadofinal.cadena_resultado =  derecha.cadena_resultado;
                    resultadofinal.posicion_inicial = nuevo_resultado_in_derecha;
                    resultadofinal.posicion_final = nuevo_resultado_fin_derecha;
                    return resultadofinal;
                   
                    //return derecha.cadena_resultado;
                }
            }
        }
    }

}

bool voval_or_consonat(char caracter) {

    char tmp = tolower(caracter);
    int vocal= false ;

    switch (tmp){

        case 'a' :
        case 'e' :
        case 'i' :
        case 'o' :
        case 'u' :
            vocal = true;
            break;
        default:
            vocal = false;
            break;
    }
    return  vocal;

}

resultado iterativo(string cadena_principal){
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
         }

      */
        /*
        std::cout << ""<<std::endl;
        std::cout << "Lectra actual " << letra << " posicion " << i << std::endl;
        std::cout << "Vocal ? " << voval_or_consonat(letra) << std::endl;
        std::cout << "Cadenalarga  " << cadenalarga << std::endl;
        std::cout << "posicion_final" << posicion_ultimaletra_cadenalarga << std::endl;
        std::cout << "buffer actual " << buffer << std::endl;
        std::cout << "cadena_temp actual " << cadena_temp << std::endl;
        std::cout << "contador_vocales " << contador_vocales << std::endl;
        std::cout << "contador_consonantes  " << contador_consonantes << std::endl;*/

    }
    //Ultima comprobacion
    if (not buffer.empty() && buffer.length() > cadenalarga.length()) {
        cadenalarga = buffer;
        posicion_ultimaletra_cadenalarga = posicion_ultimaletra_cadenalarga_buffer;
    }

    resultado result;
    result.cadena_actual=cadena_principal;
    result.posicion_final=posicion_ultimaletra_cadenalarga;
    result.posicion_inicial=result.posicion_final-(cadenalarga.length()-1);
    result.cadena_resultado=cadenalarga;

    return result;
}



resultado recur(resultado cadenaprincipal){
    if(cadenaprincipal.cadena_actual.length() <= 8){
        return  iterativo(cadenaprincipal.cadena_actual);
    } else{
        string cadena_total_actual= cadenaprincipal.cadena_actual;
        
        vector<resultado> lista_3_resultados = dividide_3(cadenaprincipal.cadena_actual);
        lista_3_resultados[0] = recur(lista_3_resultados[0]);
        lista_3_resultados[1] = recur(lista_3_resultados[1]);
        lista_3_resultados[2] = recur(lista_3_resultados[2]);

        return juntar(cadena_total_actual,lista_3_resultados[0],lista_3_resultados[1],lista_3_resultados[2]);


    }
}

int main() {
    /*cout << "Intruduce la cadena si no introduces nada se autogenerará una" << endl;
    string cadena = "";
    do{
        getline(cin,cadena);
        if (!cadena.empty()){
            cout <<" Calculando solucion para "<<cadena << endl;
            resultado solucion_directa = iterativo(cadena);
            resultado solucion= solucion.cadena_resultado=cadena;
        }

    }while (cadena.compare("exit")==0);

    */
    /*
    string cadena="cccaacccaaaaacccaa";

    cout << cadena << endl;
    resultado solucion_directa = iterativo(cadena);
    cout << solucion_directa.posicion_inicial << " Solucion " << solucion_directa.cadena_resultado <<" "<< solucion_directa.posicion_final << endl;


    cout << cadena << endl;
    resultado solucion;
    solucion.cadena_actual=cadena;
    solucion=recur(solucion);
    cout << solucion.posicion_inicial << " Solucion " << solucion.cadena_resultado <<" "<< solucion.posicion_final << endl;


    */

    for (int i = 0; i < 10; ++i) {
        string cadena = random_string(4000);
        //cout << cadena << endl;
        resultado solucion_directa = iterativo(cadena);
        cout << solucion_directa.posicion_inicial << " Solucion " << solucion_directa.cadena_resultado << " "
             << solucion_directa.posicion_final << endl;
        resultado solucion;
        solucion.cadena_actual = cadena;
        solucion = recur(solucion);
        cout << solucion.posicion_inicial << " Solucion " << solucion.cadena_resultado << " " << solucion.posicion_final
             << endl;
        if (solucion_directa.cadena_resultado.compare(solucion.cadena_resultado) != 0) {
            cout << " ERROR " << endl;

        }


        //
    }

}