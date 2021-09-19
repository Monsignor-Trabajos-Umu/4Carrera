import Expresiones
import ManipulaListas

main :: IO()
main = putStrLn "Hola"


ejExpr :: Expr
ejExpr = Apl Mul e1 e2 where 
        e1 = Apl Sum (Num 1) (Num 50)
        e2 = Apl Res (Num 25) (Num 10)


solucion:: Expr -> [Int] -> Int -> Bool
sol