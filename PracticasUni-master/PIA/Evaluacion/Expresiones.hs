module Expresiones where
data Op = Sum | Res | Mul | Div

ops :: [Op]
ops = [Sum,Res,Mul,Div]


--1. Declarar Op como instancia de la clase Show
instance Show Op where
    show Sum =  "+"
    show Res =  "-"
    show Mul =  "*"
    show Div =  "/"
--2. Definir la funci�n valida 
valida :: Op -> Int -> Int -> Bool
valida Sum _ _ = True
valida Res x y = x > y
valida Mul _ _ = True
valida Div x y = y /= 0 && x `mod` y == 0

--3. Definir la funci�n aplica
aplica :: Op -> Int -> Int -> Int
aplica Sum x y = x + y
aplica Res x y = x - y
aplica Mul x y = x * y
aplica Div x y = x `div` y



data Expr = Num Int | Apl Op Expr Expr

ejm ::Expr
ejm = Apl Sum (Num 2)(Num 2)

--4. Declarar Expr como instancia de la clase Show
instance Show Expr where
    show (Num int) = show int
    show (Apl op x y) = paren x  ++ show op ++ paren y where
        paren (Num int) = show int
        paren e = "(" ++ show(e) ++ ")"



--5. Definir la funci�n numeros 
ejmNumero ::Expr
ejmNumero = Apl Mul (Apl Sum (Num 2) (Num 3)) (Num 7)

numeros :: Expr -> [Int]
numeros (Num int) = [int]
numeros (Apl _ x y) = numeros x ++ numeros y 



--6. Definir la funci�n valor

valor :: Expr -> [Int]
valor (Num int) = [int]
valor (Apl op x y) = [aplica op x' y' | 
                        x' <- valor x,
                        y' <- valor y,
                        valida op x' y']

