//
// Created by edymola on 19/03/18.
//
#include <iostream>
#include "Consonate_o_vocal.h"
#include <tuple>
#include <math.h>

#ifndef AED2_PRACTICAS_DIRECCTA_H
#define AED2_PRACTICAS_DIRECCTA_H


class direccta {

public:

    std::string cadena_principal;
    std::tuple<std::string, int> resultado_tupla_posicion;


    std::string get_resultado_string(){
        return  std::get<0>(resultado_tupla_posicion);
    }
    int get_resultado_posicion_final(){
        return  std::get<1>(resultado_tupla_posicion);
    }
    int get_resultado_posicion_inicial(){
       return static_cast<int>(get_resultado_posicion_final() - get_resultado_string().length());
    }


    void set_cadena(std::string cadena) {
        cadena_principal = cadena;
    }

    bool resolve() {
        return __getcadena();
    }

private:

    bool __getcadena();
};


#endif //AED2_PRACTICAS_DIRECCTA_H
