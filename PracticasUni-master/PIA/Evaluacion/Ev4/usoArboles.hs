module UsoArboles where
import Arbol

import Data.List

ejemploArbol :: ArbolE Int
ejemploArbol = Rama (Rama (Hoja 1) 2 (Hoja 3) ) 4 (Rama (Hoja 5) 6 (Hoja 7) ) 

aplanaen2:: ArbolE a -> ([a],[a])
aplanaen2 Vacio = ([],[])
aplanaen2 (Hoja v) = ([],[v])
aplanaen2 (Rama a1 v a2) =(fst(aplanaen2 a1) ++ [v] ++ fst(aplanaen2 a2),snd(aplanaen2 a1)++ snd(aplanaen2 a2))


suma ::Num a => ArbolE a -> (a,a)
suma Vacio = (0,0)
suma (Hoja v) = (0,v)
suma (Rama a1 v a2) =(fst(suma a1) + v + fst(suma a2),snd(suma a1)+ snd(suma a2))



crearArbol':: Ord a => [a] -> ArbolE a -> ArbolE a
crearArbol' [] a = a
crearArbol' (x:[]) a = insertar x a
crearArbol' (x:xs) a =  crearArbol' xs (insertar x a)

crearArbol :: Ord a => [a] -> ArbolE a
crearArbol xs = crearArbol' xs Vacio 


main :: IO()
main = do
    putStrLn "Introduce la lista de numeros"
    lista <- getLine
    let nums = map read (words lista)
    putStrLn "La lista ordenada es:"
    print (crearArbol nums)
    imprime (aplanar (crearArbol nums))

imprime:: [Int] -> IO()
imprime [] = return ()
imprime (e:es) = do 
    print e
    imprime es