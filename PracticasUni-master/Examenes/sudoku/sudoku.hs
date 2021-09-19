import Data.List
-- 1
facil :: Matriz Char
facil =   M ["2....1.38",
                           "........5",
                           ".7...6...",
                           ".......13",
                           ".981..257",
                           "31....8..",
                           "9..8...2.",
                           ".5..69784",
                           "4..25...."]


type Fila a = [a]

data Matriz a = M [Fila a]

instance (Show a) => Show (Matriz a) where
    show = muestraSudoku 

separaFila :: String
separaFila  = "||-----||-----||-----||\n"

separaBloque :: String
separaBloque  = "||=====||=====||=====||\n"

-- Vamos a comprobar que el sudoku sea de 9 no vaya a ser que seamos subnormales.
muestraSudoku:: (Show a) => Matriz a -> String
muestraSudoku (M []) = separaBloque
muestraSudoku (M filas)
    | length filas == 9 = muestraSudoku' filas ++ separaBloque
    | otherwise = error "El sudoku no es 9x9"

-- Nuestro sudoku es 9x9
muestraSudoku':: (Show a) => [Fila a] -> String
muestraSudoku' (f1:f2:f3:fs) = separaBloque ++ pintafila f1 ++ "\n"
                                ++ separaFila ++ pintafila f2 ++ "\n"
                                ++ separaFila ++ pintafila f3 ++ "\n"
         
-- ||2|.|.||.|.|1||.|3|8||
-- Cutre si pero las funciones se vuelven locas con los tipos a 
pintafila :: (Show a) => Fila a -> String
pintafila (x1:x2:x3:x4:x5:x6:x7:x8:x9:_) =  "||" ++ showClean x1 ++ "|" ++ showClean x2 ++ "|" ++ showClean x3 ++ "||" ++
                                                showClean x4 ++ "|" ++ showClean x5 ++ "|" ++ showClean x6 ++ "||" ++
                                                showClean x7 ++ "|" ++ showClean x8 ++ "|" ++ showClean x9 ++ "||" 
pintafila _ = error "El sudoku no es valido"

showClean::(Show a) => a -> String
showClean x = read (show [x])


-- 
listaAmatriz ::  [[a]] -> Matriz a