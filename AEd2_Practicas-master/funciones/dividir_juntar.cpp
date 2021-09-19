//
// Created by edymola on 31/03/18.
//

#include "dividir_juntar.h"

dividir_juntar::dividir_juntar(string cadena) {
    //numero_divisiones = 2

    this->cadena = cadena;


}

void dividir_juntar::dividir() {

    // cccaaccc 8 4

    int temp = (int(floor(this->cadena.length() / 2)));
    cout << temp << " longitud total " << this->cadena.length() << endl;
    temp = temp;
    /*
    for (int i = 0; i < numero_divisiones; ++i) {

        string cadena_temp = string(this->cadena.begin(), this->cadena.begin() + temp);










    }
        */


    /* [begin    begin+temp]  [begin+temp+1     end]*/
    string cadena_temp = string(this->cadena.begin(), this->cadena.begin() + temp);

    this->lista_cadenas.push_back(cadena_temp);

    cadena_temp = string(this->cadena.begin() + temp - 4, this->cadena.begin() + temp + 1 + 3);


    this->lista_cadenas.push_back(cadena_temp);

    cadena_temp = string(this->cadena.begin() + temp, this->cadena.end());

    this->lista_cadenas.push_back(cadena_temp);


}

string
dividir_juntar::juntar(vector<string> cadenas, vector<string> resultados, vector<int> inicio, vector<int> final) {

    cout << "Esto va" << endl;

    int accareo_para_cadena_2 = cadenas[0].length() - 4;


    int accareo_para_cadena_3 = cadenas[0].length();

    int nuevo_resultado1_ini = inicio[0];
    int nuevo_resultado1_fin = final[0];


    int nuevo_resultado2_ini = inicio[1] + accareo_para_cadena_2;
    int nuevo_resultado2_fin = final[1] + accareo_para_cadena_2;

    int nuevo_resultado3_ini = inicio[2] + accareo_para_cadena_3;
    int nuevo_resultado3_fin = final[2] + accareo_para_cadena_3;

    cout << nuevo_resultado1_ini << " " << nuevo_resultado1_fin << endl;
    cout << nuevo_resultado2_ini << " " << nuevo_resultado2_fin << endl;
    cout << nuevo_resultado3_ini << " " << nuevo_resultado3_fin << endl;


    if (resultados[0].length() == 0 && resultados[1].length() == 0 && resultados[2].length() == 0) {
        // 0,0,0
        cout << "No hay solucion " << endl;
    } else {
        if (resultados[0].length() == 0 && resultados[1].length() == 0 != resultados[2].length()) {
            // 0,0,X
            return resultados[2];


        } else if (resultados[0].length() == 0 && resultados[1].length() != 0 && resultados[2].length() == 0) {
            //0,X,0
            return resultados[1];
        } else if (resultados[0].length() != 0 && resultados[1].length() == 0 && resultados[2].length() == 0) {
            //X,0,0
            return resultados[0];

        } else if (resultados[0].length() != 0 && resultados[1].length() != 0 && resultados[2].length() == 0) {
            //X,X,0

            if (nuevo_resultado1_fin == nuevo_resultado2_ini) {
                return resultados[0] + resultados[1];
            } else {
                if (resultados[0].length() >= resultados[1].length()) {
                    return resultados[0];
                } else {
                    return resultados[1];
                }

            }


        } else if (resultados[0].length() != 0 && resultados[1].length() == 0 && resultados[2].length() != 0){
            //X,0,X

            if (nuevo_resultado1_fin == nuevo_resultado3_ini) {
                return resultados[0] + resultados[2];
            } else {
                if (resultados[0].length() >= resultados[2].length()) {
                    return resultados[0];
                } else {
                    return resultados[2];
                }

            }
        }else if (resultados[0].length() == 0 && resultados[1].length() != 0 && resultados[2].length() != 0){
            //0,X,X

            if (nuevo_resultado2_fin == nuevo_resultado3_ini) {
                return resultados[1] + resultados[2];
            } else {
                if (resultados[1].length() >= resultados[2].length()) {
                    return resultados[1];
                } else {
                    return resultados[2];
                }

            }
        }else{
            //X,Y,Z
            string temp = "";
            if (nuevo_resultado1_fin == nuevo_resultado2_ini) {
                //XY,Z
                temp = resultados[0] + resultados[1];
                if (nuevo_resultado2_fin==nuevo_resultado3_ini){
                    //XYZ
                    return temp+resultados[2];
                }else{if (temp.length() >= resultados[2].length()) {
                        // XX
                        return temp;

                    } else {
                        //Z
                        return resultados[2];
                    }

                }
            } else if(nuevo_resultado2_fin==nuevo_resultado3_ini){
                //X,YZ
                temp = resultados[1] + resultados[2];
                /* imposible porque se hubiera comprobado en el caso anterior
                if (nuevo_resultado1_fin==nuevo_resultado2_ini){
                    //XYZ
                    return temp+resultados[2];*/
                {if (temp.length() > resultados[1].length()) {
                        // YZ
                        return temp;

                    } else {
                        //X
                        return resultados[1];
                    }

                }

            }
            // else if(nuevo_resultado1_fin == nuevo_resultado3_ini) imposible porque hay algo siempre enmedio
            else{
                // X / Y / Z
                if (resultados[0].length()>= resultados[1].length() && resultados[0].length()>= resultados[2].length()){
                    return  resultados[0];
                }else if(resultados[1].length()> resultados[0].length() && resultados[1].length()>= resultados[2].length()){
                    return  resultados[1];
                }else{
                    return  resultados[2];
                }
            }
        }
    }

}















