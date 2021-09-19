import ManipulaListas
import Expresiones
import Data.List

-- 1 

ejExpr :: Expr 
ejExpr = Apl Mul e1 e2 where 
    e1 = Apl Sum (Num 1) (Num 50)
    e2 = Apl Res (Num 25) (Num 10)

solucion :: Expr -> [Int] -> Int -> Bool
solucion exp lista va = completo && valido where
    -- Numero de lista pertenecen a exp 
    completo = null( e \\ lista )
    valido = valor exp  == [va]
    e = numeros exp 
-- combina (Num 2) (Num 3) = [2+3,2-3,2*3,2/3]
combina :: Expr -> Expr -> [Expr]
combina e1 e2 = [Apl op e1 e2 | op <-ops]
-- expresiones [2,3,5] = [2+(3+5),2-(3+5),2*(3+5),2/(3+5),2+(3-5),2-(3-5), 2*(3-5),2/(3-5),2+(3*5),2-(3*5),2*(3*5),2/(3*5), ...
expresiones ::  [Int] -> [Expr]
expresiones [] = []
expresiones [x] = [(Num x)]
expresiones x = [e | (n1, n2)<- particiones x ,
                 exp1 <- expresiones n1 ,
                 exp2 <-expresiones n2,
                 e <- combina exp1 exp2
                 ]


-- soluciones [1,3,7,10,25,50] 765
-- La solucion no tiene porque llevar el todos los valores de soluciones
-- Sabemos que nuestra expresion esta formada por los numeros
soluciones:: [Int] -> Int -> [Expr]
soluciones x n = [ex | x' <- elecciones x,
                    ex <- expresiones x',
                    valor ex == [n]]

main :: IO()
main = do 
    putStrLn "Guap@ dime los numeros"
    stringNumeros <- getLine 
    let cosas =  map (read::String->Int) (words stringNumeros)
    putStrLn  "Y cual es el objetivo "
    objetivo <- readLn  
    let valores = soluciones cosas objetivo
    putStrLn  "Las posibles soluciones son"
    prettyprint valores

prettyprint:: [Expr] -> IO()
prettyprint [] = return ()
prettyprint (x:xs)=  do
                    print x 
                    prettyprint xs 
