import Data.List
import Data.List.HT
import Data.List.Split
type Fila a = [a]
data Matriz a = Matriz [Fila a]

instance Show a => Show (Matriz a) where
    show a = imprime a

--- fila -> | lista1 | lista2| lista3 |
--- listaN -> | numero1|numero2|numero3 |

--- [a0,a1,a2]
imprime3Fila :: Show a => [a] -> String
imprime3Fila x = "\n||=====||=====||=====||\n" ++ (intersperse '|' (show (x !! 0))) ++ "\n||-----||-----||-----||\n" 
                    ++ (intersperse '|' (show (x !! 1))) ++ "\n||-----||-----||-----||\n" ++ (intersperse '|' (show (x !! 2)))

--- Matriz a  = [[a]]
-- listasFilas = [[a1,a2,a3],[a4,a5,a6],....]
imprime :: Show a => Matriz a -> String
imprime (Matriz listaFilas) = concat (map imprime3Fila listasFilas) ++ "\n||=====||=====||=====||\n" where
                                listasFilas = chunksOf 3 listaFilas