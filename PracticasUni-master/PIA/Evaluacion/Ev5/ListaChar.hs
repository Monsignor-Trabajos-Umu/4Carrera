import ListaPar  
import Data.Char
import System.IO


type ListaPCh = ListaP2 Char
-- [(Int,a)]

pruebaChar :: ListaPCh
pruebaChar = [(2,'a'),(3,'a'),(2,'a'),(4,'a')]


listaAcadena :: ListaPCh -> String
listaAcadena xs = concat [show n ++ [c] | (n,c) <- xs]


cadenaComprimida ::  String -> String
cadenaComprimida  = listaAcadena . comprimida

                    -- [(int,Char)]
cadenaAlista ::  String -> ListaPCh
cadenaAlista [] = []
cadenaAlista xs = (read num,char) : cadenaAlista resto where
    (num,(char:resto)) = span isNumber xs


cadenaExpandida ::  String -> String
cadenaExpandida =  expandida . cadenaAlista



main ::  IO()
main = bucle


bucle :: IO ()
bucle = do 
    valor <- menu
    case valor of
        "C" -> putStrLn "Codificando" >> codificando >> bucle
        "D" -> putStrLn "Descodificando" >> descodificando >> bucle
        "Q" -> putStrLn "hasta luego tt" 
    
menu :: IO String
menu = do
    putStrLn "Que quieres hacer "
    putStrLn "C <- Codificar string"
    putStrLn "D <- Descodificar string"
    putStrLn "Q <- Salir"
    (valor:_) <- getLine
    let valido = [toUpper valor]
    if (elem valido ["C","D","Q"]) then return valido else menu



codificando:: IO ()
codificando = do 
    putStrLn "Que cadena quieres codificar "
    cadena  <- getLine 
    putStr "Cadena codificada = "
    putStrLn (cadenaComprimida cadena)


descodificando:: IO ()
descodificando = do 
    putStrLn "Que cadena quieres descodificar "
    cadena  <- getLine 
    putStr "Cadena descodificanda = "
    putStrLn (cadenaExpandida cadena)