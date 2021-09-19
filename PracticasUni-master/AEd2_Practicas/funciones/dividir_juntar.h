//
// Created by edymola on 31/03/18.
//

#ifndef AED2_PRACTICAS_DIVIDIR_H
#define AED2_PRACTICAS_DIVIDIR_H

#include <iostream>
#include <vector>
#include <tuple>
#include <math.h>
using namespace std;
class dividir_juntar {
public:

    string cadena;
    vector <string> lista_cadenas;



    dividir_juntar(string cadena);

    void dividir();

    string juntar(vector<string> cadenas,vector<string> resultados, vector <int> inicio,vector<int> final);


};


#endif //AED2_PRACTICAS_DIVIDIR_H
