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
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
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
    cout << temp << " longitud total " << cadena.length() << endl;
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

resultado juntar(resultado izquierda, resultado centro,resultado derecha) {
    //string izquierda, vector<string> resultados, vector<int> inicio, vector<int> final
    resultado resultadofinal;


    cout << "Juntar" << endl;

    int accareo_para_cadena_2 = static_cast<int>(izquierda.cadena_actual.length() - 4);


    int accareo_para_cadena_3 = izquierda.cadena_actual.length();
    
    int nuevo_resultado1_ini = izquierda.posicion_inicial;
    int nuevo_resultado1_fin = izquierda.posicion_final;


    int nuevo_resultado2_ini = centro.posicion_inicial + accareo_para_cadena_2;
    int nuevo_resultado2_fin = centro.posicion_final + accareo_para_cadena_2;

    int nuevo_resultado3_ini = derecha.posicion_inicial + accareo_para_cadena_3;
    int nuevo_resultado3_fin = derecha.posicion_final + accareo_para_cadena_3;

    cout << nuevo_resultado1_ini << " " << izquierda.cadena_resultado <<" "<< nuevo_resultado1_fin << endl;
    cout << nuevo_resultado2_ini << " " << centro.cadena_resultado <<" "<< nuevo_resultado2_fin << endl;
    cout << nuevo_resultado3_ini << " " << derecha.cadena_resultado <<" "<< nuevo_resultado3_fin << endl;


    if (izquierda.cadena_resultado.length() == 0 && centro.cadena_resultado.length() == 0 && derecha.cadena_resultado.length() == 0) {
        // 0,0,0
        cout << "No hay solucion " << endl;
        resultadofinal.cadena_resultado = "";
        resultadofinal.posicion_inicial = 0;
        resultadofinal.posicion_final = 0;
        return resultadofinal;
    } else {
        if (izquierda.cadena_resultado.length() == 0 && centro.cadena_resultado.length() == 0 && derecha.cadena_resultado.length() !=0) {
            // 0,0,X

            resultadofinal.cadena_resultado = derecha.cadena_resultado;
            resultadofinal.posicion_inicial = derecha.posicion_inicial;
            resultadofinal.posicion_final = derecha.posicion_final;
            return resultadofinal;


        } else if (izquierda.cadena_resultado.length() == 0 && centro.cadena_resultado.length() != 0 && derecha.cadena_resultado.length() == 0) {
            //0,X,0
            resultadofinal.cadena_resultado = centro.cadena_resultado;
            resultadofinal.posicion_inicial = centro.posicion_inicial;
            resultadofinal.posicion_final = centro.posicion_final;
            return resultadofinal;
        } else if (izquierda.cadena_resultado.length() != 0 && centro.cadena_resultado.length() == 0 && derecha.cadena_resultado.length() == 0) {
            //X,0,0
            resultadofinal.cadena_resultado = izquierda.cadena_resultado;
            resultadofinal.posicion_inicial = izquierda.posicion_inicial;
            resultadofinal.posicion_final = izquierda.posicion_final;
            return resultadofinal;

        } else if (izquierda.cadena_resultado.length() != 0 && centro.cadena_resultado.length() != 0 && derecha.cadena_resultado.length() == 0) {
            //X,X,0

            if (nuevo_resultado1_fin == nuevo_resultado2_ini) {

                resultadofinal.cadena_resultado = izquierda.cadena_resultado + centro.cadena_resultado;
                resultadofinal.posicion_inicial = izquierda.posicion_inicial;
                resultadofinal.posicion_final = centro.posicion_final;
                return resultadofinal;

                //return izquierda.cadena_resultado + centro.cadena_resultado;
            } else {
                if (izquierda.cadena_resultado.length() >= centro.cadena_resultado.length()) {
                    resultadofinal.cadena_resultado = izquierda.cadena_resultado;
                    resultadofinal.posicion_inicial = izquierda.posicion_inicial;
                    resultadofinal.posicion_final = izquierda.posicion_final;
                    return resultadofinal;
                } else {
                    resultadofinal.cadena_resultado = centro.cadena_resultado;
                    resultadofinal.posicion_inicial = centro.posicion_inicial;
                    resultadofinal.posicion_final = centro.posicion_final;
                    return resultadofinal;
                }

            }


        } else if (izquierda.cadena_resultado.length() != 0 && centro.cadena_resultado.length() == 0 && derecha.cadena_resultado.length() != 0) {
            //X,0,X

            if (nuevo_resultado1_fin == nuevo_resultado3_ini) {

                resultadofinal.cadena_resultado = izquierda.cadena_resultado + derecha.cadena_resultado;
                resultadofinal.posicion_inicial = izquierda.posicion_inicial;
                resultadofinal.posicion_final = derecha.posicion_final;
                return resultadofinal;
                // return izquierda.cadena_resultado + derecha.cadena_resultado;
            } else {
                if (izquierda.cadena_resultado.length() >= derecha.cadena_resultado.length()) {

                    resultadofinal.cadena_resultado = izquierda.cadena_resultado;
                    resultadofinal.posicion_inicial = izquierda.posicion_inicial;
                    resultadofinal.posicion_final = izquierda.posicion_final;
                    return resultadofinal;
                } else {
                    resultadofinal.cadena_resultado = derecha.cadena_resultado;
                    resultadofinal.posicion_inicial = derecha.posicion_inicial;
                    resultadofinal.posicion_final = derecha.posicion_final;
                    return resultadofinal;
                }

            }
        } else if (izquierda.cadena_resultado.length() == 0 && centro.cadena_resultado.length() != 0 && derecha.cadena_resultado.length() != 0) {
            //0,X,X

            if (nuevo_resultado2_fin == nuevo_resultado3_ini) {
                resultadofinal.cadena_resultado = centro.cadena_resultado + derecha.cadena_resultado;
                resultadofinal.posicion_inicial = centro.posicion_inicial;
                resultadofinal.posicion_final = derecha.posicion_final;
                return resultadofinal;
                // return centro.cadena_resultado + derecha.cadena_resultado;
            } else {
                if (centro.cadena_resultado.length() >= derecha.cadena_resultado.length()) {

                    resultadofinal.cadena_resultado = centro.cadena_resultado;
                    resultadofinal.posicion_inicial = centro.posicion_inicial;
                    resultadofinal.posicion_final = centro.posicion_final;
                    return resultadofinal;
                    // return centro.cadena_resultado;
                } else {
                    resultadofinal.cadena_resultado = derecha.cadena_resultado;
                    resultadofinal.posicion_inicial = derecha.posicion_inicial;
                    resultadofinal.posicion_final = derecha.posicion_final;
                    return resultadofinal;
                    // return derecha.cadena_resultado;
                }

            }
        } else {
            //X,Y,Z
            string temp = "";
            if (nuevo_resultado1_fin == nuevo_resultado2_ini) {
                //XY,Z
                temp = izquierda.cadena_resultado + centro.cadena_resultado;
                if (nuevo_resultado2_fin == nuevo_resultado3_ini) {
                    //XYZ
                    resultadofinal.cadena_resultado = izquierda.cadena_resultado + centro.cadena_resultado + derecha.cadena_resultado;
                    resultadofinal.posicion_inicial = izquierda.posicion_inicial;
                    resultadofinal.posicion_final = derecha.posicion_final;
                    return resultadofinal;

                    // return temp+derecha.cadena_resultado;
                } else {
                    if (temp.length() >= derecha.cadena_resultado.length()) {
                        // XY
                        resultadofinal.cadena_resultado = izquierda.cadena_resultado + centro.cadena_resultado;
                        resultadofinal.posicion_inicial = izquierda.posicion_inicial;
                        resultadofinal.posicion_final = centro.posicion_final;
                        return resultadofinal;
                        // return temp;

                    } else {
                        //Z
                        resultadofinal.cadena_resultado = derecha.cadena_resultado;
                        resultadofinal.posicion_inicial = derecha.posicion_inicial;
                        resultadofinal.posicion_final = derecha.posicion_final;
                        return resultadofinal;
                        // return derecha.cadena_resultado;
                    }

                }
            } else if (nuevo_resultado2_fin == nuevo_resultado3_ini) {
                //X,YZ
                temp = centro.cadena_resultado + derecha.cadena_resultado;
                /* imposible porque se hubiera comprobado en el caso anterior
                if (nuevo_resultado1_fin==nuevo_resultado2_ini){
                    //XYZ
                    return temp+derecha.cadena_resultado;*/
                {
                    if (temp.length() > izquierda.cadena_resultado.length()) {
                        // YZ
                        resultadofinal.cadena_resultado = centro.cadena_resultado + derecha.cadena_resultado;
                        resultadofinal.posicion_inicial = centro.posicion_inicial;
                        resultadofinal.posicion_final = derecha.posicion_final;
                        return resultadofinal;
                        // return temp;

                    } else {
                        //X
                        resultadofinal.cadena_resultado = izquierda.cadena_resultado;
                        resultadofinal.posicion_inicial = izquierda.posicion_inicial;
                        resultadofinal.posicion_final = izquierda.posicion_final;
                        return resultadofinal;
                        // return izquierda.cadena_resultado;
                    }

                }

            }
                // else if(nuevo_resultado1_fin == nuevo_resultado3_ini) imposible porque hay algo siempre enmedio
                // cccaaccaa se comprueba en la linea 117
            else {
                // X / Y / Z
                if (izquierda.cadena_resultado.length() >= centro.cadena_resultado.length() &&
                    izquierda.cadena_resultado.length() >= derecha.cadena_resultado.length()) {

                    resultadofinal.cadena_resultado = izquierda.cadena_resultado;
                    resultadofinal.posicion_inicial = izquierda.posicion_inicial;
                    resultadofinal.posicion_final = izquierda.posicion_final;
                    return resultadofinal;
                    //return izquierda.cadena_resultado;
                } else if (centro.cadena_resultado.length() > izquierda.cadena_resultado.length() &&
                           centro.cadena_resultado.length() >= derecha.cadena_resultado.length()) {

                    resultadofinal.cadena_resultado = centro.cadena_resultado;
                    resultadofinal.posicion_inicial = centro.posicion_inicial;
                    resultadofinal.posicion_final = centro.posicion_final;
                    return resultadofinal;
                    //return centro.cadena_resultado;
                } else {
                    resultadofinal.cadena_resultado =  derecha.cadena_resultado;
                    resultadofinal.posicion_inicial = derecha.posicion_inicial;
                    resultadofinal.posicion_final = derecha.posicion_final;
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
                    posicion_ultimaletra_cadenalarga_buffer = i+1;
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

    resultado result;
    result.posicion_final=posicion_ultimaletra_cadenalarga;
    result.posicion_inicial=result.posicion_final-cadenalarga.length();
    result.cadena_resultado=cadenalarga;

    return result;
}



resultado recur(resultado cadenaprincipal){
    if(cadenaprincipal.cadena_actual.length() <= 8){
        return  iterativo(cadenaprincipal.cadena_resultado);
    } else{

        vector<resultado> lista_3_resultados = dividide_3(cadenaprincipal.cadena_resultado);


        return juntar(lista_3_resultados[0],lista_3_resultados[1],lista_3_resultados[2]);


    }
}

int main() {
    for (int i = 0; i < 10; ++i) {
        string cadena=random_string(4000);
        cout << cadena << endl;
        resultado solucion_directa = iterativo(cadena);
        resultado solucion;
        solucion.cadena_resultado=cadena;
        solucion=recur(solucion);
        cout << solucion.posicion_inicial << " Solucion " << solucion.cadena_resultado <<" "<< solucion.posicion_final << endl;
        if (solucion_directa.cadena_resultado.compare(solucion.cadena_resultado)!=0){
            cout << " ERROR "<< endl;

        }


        //
    }

}