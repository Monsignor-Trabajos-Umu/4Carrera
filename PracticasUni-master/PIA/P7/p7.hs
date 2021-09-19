module Prac7 where
-- ArbolB cualquierTipo
data ArbolB valor = Hoja
    | Rama (ArbolB valor) valor (ArbolB valor)
    deriving Show

ejArbol = Rama 
        (Rama (Rama Hoja 1 Hoja) 2 (Rama Hoja 3 Hoja))
            4 
        (Rama (Rama Hoja 5 Hoja) 6 (Rama Hoja 7 Hoja))


tama :: (Ord valor) => ArbolB valor ->Integer
tama Hoja = 0
tama (Rama iz _ der) = tama(iz) + 1 + tama(der)

aplanar :: (Ord valor) => ArbolB valor ->[valor]
aplanar Hoja = []
aplanar (Rama iz centro der) = aplanar(iz)++[centro]++aplanar(der)

elemnOrdenado :: (Ord valor) => valor -> [valor] -> Bool
elemnOrdenado valor [] = False
elemnOrdenado valor (x:xs)
        | x == valor = True
        | valor < x = False
        | otherwise = elemnOrdenado valor (xs)


--Petaba porque el tipo de elem espera un Eq a y yo le estaba pasadon un Ord valor
perteneceNoVA :: (Ord valor) => valor -> ArbolB valor -> Bool
perteneceNoVA cosa arbol  =  cosa `elemnOrdenado` (aplanar arbol)

pertenece :: (Ord valor) => valor -> ArbolB valor -> Bool
pertenece e Hoja = False
pertenece x (Rama iz centro der)
        | x == centro = True 
        | x < centro = pertenece x iz
        | x > centro = pertenece x der



insertar :: (Ord valor) => valor -> ArbolB valor -> ArbolB valor
insertar e Hoja = (Rama Hoja e Hoja)
insertar e (Rama iz x dr) 
                | e <= x = Rama (insertar e iz) x dr
                | e > x = Rama iz x (insertar e dr)



borrarListaOrd :: (Ord valor) => valor -> [valor] -> [valor]
borrarListaOrd _ [] = []
borrarListaOrd valor (x:xs)
        | x == valor = borrarListaOrd valor xs
        | valor < x = (x:xs)
        | otherwise = x:borrarListaOrd valor xs



-- Vamos a hacer la perrisma arbol -> lista -> arbol
borrar :: (Ord valor) => valor -> ArbolB valor -> ArbolB valor
borrar e Hoja = Hoja
borrar e (Rama iz x dr) = nuevoArbol where
        lista = aplanar(Rama iz x dr)
        listaSinElem = borrarListaOrd e lista
        nuevoArbol = foldr insertar Hoja listaSinElem
        
creaArbolLista :: (Ord valor) => [valor] -> ArbolB valor
creaArbolLista = foldr insertar Hoja

ordenaConArbol ::(Ord valor) => [valor] -> [valor]
ordenaConArbol = aplanar . creaArbolLista 