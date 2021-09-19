import           Data.Char
import           Data.List
import           Data.Maybe

type Mensaje = String

minuscula2int :: Char -> Int
minuscula2int c = ord c - ord 'a'

mayuscula2int :: Char -> Int
mayuscula2int c = ord c - ord 'A'

int2minuscula :: Int -> Char
int2minuscula x = chr (ord 'a' + x)

int2mayuscula :: Int -> Char
int2mayuscula x = chr (ord 'A' + x)

desplaza :: Int -> Char -> Char
desplaza x c | isLower c = int2minuscula ((x + minuscula2int c) `mod` 26)
             | isUpper c = int2mayuscula ((x + mayuscula2int c) `mod` 26)
             | otherwise = c



codifica :: Int -> Mensaje -> Mensaje
codifica x ms = [ desplaza x m | m <- ms ]

codifica2 :: Int -> Mensaje -> Mensaje
codifica2 x ms = map (desplaza x) ms

porcentaje :: Int -> Int -> Float
porcentaje x y = 100 * (fromIntegral x / fromIntegral y)
-- Quita cosas que no son letras
soloLetras :: Mensaje -> Mensaje
soloLetras ms = filter (isLetter) ms

soloLetras2 :: Mensaje -> Mensaje
soloLetras2 ms = [ m | m <- ms, isLetter m ]

-- Cuenta las veces que sale un char en el mensaje
ocurrencias :: Char -> Mensaje -> Int
ocurrencias c str = length (filter (c ==) str)


-- Locura de frecuencias

frecuencias :: Mensaje -> [Float]
frecuencias [] = []
frecuencias ms =
    [ porcentaje (ocurrencias m msAllLower) longitudMensaje
    | m <- ['a' .. 'z']
    ]  where
    msAllLower      = map (toLower) ms
    longitudMensaje = length (soloLetras ms)

-- Chi cuadrado

chiCuad :: [Float] -> [Float] -> Float
chiCuad x y = sum [ (os - es) ^ 2 / es | (os, es) <- zip x y ]

-- Mueve elementos

rota :: Int -> [a] -> [a]
rota x ms = drop x ms ++ take x ms


-- Locura de desodificar


tabla :: [Float]
tabla =
    [ 12.53
    , 1.42
    , 4.68
    , 5.86
    , 13.68
    , 0.69
    , 1.01
    , 0.70
    , 6.25
    , 0.44
    , 0.01
    , 4.97
    , 3.15
    , 6.71
    , 8.68
    , 2.51
    , 0.88
    , 6.87
    , 7.98
    , 4.63
    , 3.93
    , 0.90
    , 0.02
    , 0.22
    , 0.90
    , 0.52
    ]


getIndex :: Ord a => [a] -> Int
getIndex x = fromJust (elemIndex (minimum  x) x)

descifra :: Mensaje -> Mensaje
descifra ms = codifica (-antiDesp) ms where 
        antiDesp = getIndex desviacionesChi
        desviacionesChi = [chiCuad tPC tabla | tPC <-posiblesDistribuciones]
        posiblesDistribuciones = [rota n distribucionBase | n<-[0..25]]
        distribucionBase = frecuencias ms

