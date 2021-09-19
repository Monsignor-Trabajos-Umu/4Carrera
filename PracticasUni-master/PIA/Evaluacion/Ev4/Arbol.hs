module Arbol(ArbolE(..),tamArbol,aplanar,insertar) where 

data ArbolE typo = Vacio |
    Hoja typo |
    Rama (ArbolE typo) typo (ArbolE typo) 
    deriving (Show)

tamArbol :: ArbolE typo -> Int
tamArbol Vacio = 0
tamArbol (Hoja _ ) = 1
tamArbol (Rama a1 _ a2) = 1 + tamArbol a1 + tamArbol a2

aplanar ::ArbolE a -> [a]
aplanar Vacio = []
aplanar (Hoja a) = [a]
aplanar (Rama a1 a2 a3) = aplanar a1 ++ [a2] ++ aplanar a3

insertar :: (Ord a) => a-> ArbolE a -> ArbolE a
insertar a Vacio = Hoja a
insertar a (Hoja p)
    | a <= p =  Rama (Hoja a) p (Vacio)
    | otherwise = Rama (Hoja p) a (Vacio)
insertar a (Rama a1 v a2) 
    | a <= v = Rama (insertar a a1) v a2 
    | otherwise = Rama a1 v (insertar a a2) 