module Prac6 where
type Persona = String
type Libro =String

type DB = [(Persona,Libro)]
type NumEjem = [(Libro,Int)]


-- Dada una persona, obtener los libros que tiene en prestamo (funcion libros).
libros :: DB -> Persona -> [Libro]
libros db per = [lib' | (per',lib') <- db , per' == per ]


-- Dado un libro obtiene el numero de ejemplares del mismo
ejempla :: NumEjem -> Libro->(Libro,Int)
ejempla nj lib = head [(lib',int') | (lib',int') <- nj ,lib'==lib]

-- Añande un nuevo ejemplar a la database NumEjem
nuevoEjemplar:: NumEjem -> Libro -> NumEjem
nuevoEjemplar nj lib = [(lib,1)] ++ nj


devolverEjemplar :: NumEjem -> Libro -> NumEjem
devolverEjemplar nj lib = [(lib',int'+1) | (lib',int') <- nj ,lib'==lib]

-- Saca un ejemplar de la dataabse NumEjem
sacarEjemplar :: NumEjem -> Libro -> NumEjem
sacarEjemplar nj lib = [(lib',int'-1) | (lib',int') <- nj ,lib'==lib]


-- Comprobamos si hay algun libro disponible
disponibleLibro :: NumEjem -> Libro -> Bool
disponibleLibro nj lib =  snd(ejempla nj lib) >= 1



dataBaseDb :: DB
dataBaseDb = [("Juan","LUNA DE PLUTON"),("PEDRO","LUNA DE PLUTON"),("Luis","LUNA DE PLUTON")]
dataBaseNJ :: NumEjem 
dataBaseNJ = [("LUNA DE PLUTON",1)]


realizarPrestamo :: DB -> NumEjem -> Persona -> Libro -> (DB,NumEjem)
realizarPrestamo db nj per lib 
    | disponibleLibro nj lib = (db ++ [(per,lib)],devolverEjemplar nj lib)
    | otherwise = error ( "No quedan ejemplares de " ++ lib)

devolverPrestamo :: DB -> NumEjem -> Persona -> Libro -> (DB,NumEjem)
devolverPrestamo db nj per lib = ([pres | pres <-db, pres /= (per,lib)],devolverEjemplar nj lib)