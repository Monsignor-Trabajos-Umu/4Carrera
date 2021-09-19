module MainModule where

import Pila
import System.IO
import Data.Char
import Data.List


main :: IO()
main = bucle



bucle :: IO()
bucle = do
    putStrLn "Venga vamos a calcular cosas"
    v <- menu
    case v of
        'c' -> calcula >> bucle
        's' -> putStrLn "Hasta luego tt"


menu :: IO Char
menu =  do 
    putStrLn "MENU COSAS"
    putStrLn "C calculame cosas"
    putStrLn "S sacame de aqui"
    v <- getLine 
    let trueV = toLower (head v)
    if (elem trueV ['c','s']) then return trueV else menu




resuelve :: [String] -> Pila Int -> Int 
resuelve [] pila 
    | esVacia(desapila pila) = cima pila
    | otherwise = error "Pila con operaciones sin evualr"

resuelve (x:xs) pila = resuelve xs (opera x pila)


suma:: Pila Int -> Pila Int
suma pila = apila x (desapila (desapila pila)) where 
    x = cima (desapila pila) + cima pila

opera :: String -> Pila Int -> Pila Int 
opera x pila 
    | x == "+" = suma pila
    | otherwise = apila (read x) pila



calcula :: IO()
calcula =do  
    putStrLn "Hola tt "
    strinData <- getLine 
    
    bucle