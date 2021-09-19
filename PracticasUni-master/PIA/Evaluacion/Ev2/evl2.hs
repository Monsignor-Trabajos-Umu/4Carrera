
import Data.Char
import Data.List
import System.IO

type Mensaje = String


minusculaAint:: Char -> Int
minusculaAint c = ord c - ord 'a'

intAminuscula:: Int -> Char
intAminuscula c = chr (ord 'a' +  c)

mayusculaAint:: Char -> Int
mayusculaAint c = ord c - ord 'A'

intAmayuscula:: Int -> Char
intAmayuscula c = chr (ord 'A' +  c)

-- desplaza

desplaza :: Int -> Char -> Char
desplaza n c 
    | elem c ['a'..'z'] = intAminuscula ((minusculaAint c+n) `mod` 26)
    | elem c ['A'..'Z'] = intAmayuscula ((mayusculaAint c+n) `mod` 26)
    | otherwise         = c

    
codifica:: Int -> Mensaje -> Mensaje
codifica n ms = [desplaza n m | m <-ms]



porcentaje :: Int -> Int -> Float
porcentaje n m =(fromIntegral (n) / fromIntegral(m)) * 100

esLetra :: Char -> Bool
esLetra c = elem c ['a'..'z'] || elem c ['A'..'Z']

soloLetras :: Mensaje -> Mensaje
soloLetras ms = [m | m <-ms,esLetra(m)]


ocurrencias :: Char -> Mensaje -> Int
ocurrencias _ [] = 0
ocurrencias c (m:ms)
    | m == c = 1 + ocurrencias c (ms)
    | otherwise = 0 + ocurrencias c (ms)
    


frecuencias::Mensaje -> [Float]
frecuencias xs = 
    [porcentaje (ocurrencias x xs') n | x <- ['a'..'z']]
    where xs' = [toLower x | x <- xs]
          n   = length (soloLetras xs)

-- 9
chiCuad :: [Float] -> [Float] -> Float
chiCuad os es = sum [((o-e)^2)/e |(o,e) <-zip os es]

-- 10

rota :: Int -> [a] -> [a]
rota n ms = drop n ms ++ take n ms



tabla ::  [Float]
tabla = [12.53, 1.42, 4.68, 5.86, 13.68, 0.69, 1.01, 0.70,
        6.25, 0.44,0.01, 4.97, 3.15, 6.71, 8.68, 2.51, 0.88, 6.87,
        7.98, 4.63,3.93, 0.90, 0.02, 0.22, 0.90, 0.52]

-- Descifra
descifra :: Mensaje -> Mensaje
descifra xs = codifica (-desp) xs where
    desp = getPositionValor (minimum tabChi) tabChi
    tabChi = [chiCuad (rota n tabla') tabla | n <- [0..25]]
    tabla' = frecuencias xs

getPositionValor:: Eq a => a -> [a] -> Int
getPositionValor valor lista = head [i| (x,i) <- zip lista [0..],x==valor]


-- Menu

main :: IO()
main = bucle

bucle :: IO ()
bucle = do
        opc <- menu
        let nopc =  toLower opc
        putStrLn ("Opcion " ++ show nopc)
        case opc of
            'c' -> codificar >> bucle
            'd' -> descifrar >> bucle
            's' -> putStrLn "Fin del Programa"

        

menu :: IO Char
menu = do
    putStrLn "CIFRADO DEL CESAR"
    putStrLn "c.- Codificar una entrada"
    putStrLn "d.- Descifrar una entrada"
    putStrLn "s.- Salir del programa"
    putStrLn "---------------------------Teclear Opcion: "
    x <- getChar
    if (elem x "cCdDsS") then return x
    else menu

codificar :: IO ()
codificar = do
    putStrLn "Introduce el desplazamiento: "
    d <- readLn
    putStrLn "Introduce la cadena a codificar"
    se <- getLine
    let ss=codifica d se 
    print ss

descifrar :: IO ()
descifrar = do
    putStrLn "Introduce la cadena a descifrar"
    ss <- getLine
    let se=descifra ss 
    print se
    