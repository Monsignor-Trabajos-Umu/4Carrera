//
// Created by edymola on 19/03/18.
//

#include <iostream>

bool voval_or_consonat(char caracter) {

    char tmp = tolower(caracter);
    int vocal=0;

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


