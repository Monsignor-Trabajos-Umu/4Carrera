module Expresiones where 
data Op = Sum | Res | Mul | Div

ops :: [Op]
ops = [Sum,Res,Mul,Div]


--1. Declarar Op como instancia de la clase Show
instance Show Op where
    show Sum = "+"
    show Res = "-"
    show Mul = "*"
    show Div = "/"


--2. Definir la funci�n valida 
-- x y > 0 
valida:: Op->Int->Int-> Bool
valida Sum _ _ = True
valida Res x y = x > y
valida Mul _ _ = True
valida Div x y = y/=0 && (x `mod` y) == 0


--3. Definir la funci�n aplica
aplica:: Op->Int->Int->Int
aplica Sum x y = x + y
aplica Res x y = x - y
aplica Mul x y = x * y
aplica Div x y = x `div` y

data Expr = Num Int | Apl Op Expr Expr

--4. Declarar Expr como instancia de la clase Show

instance Show Expr where
    show (Num x) = show x
    show (Apl op ex1 ex2) = "(" ++ show ex1 ++ show op ++ show ex2 ++ ")"
prueba:: Expr
prueba =  Apl Mul (Apl Sum (Num 2) (Num 3)) (Num 7)

--5. Definir la funci�n numeros 

numeros:: Expr -> [Int]
numeros (Num x) = [x]
numeros (Apl op ex1 ex2) = numeros ex1 ++ numeros ex2

--6. Definir la funci�n valor
valor:: Expr -> [Int]
valor (Num x) = [x]
valor (Apl op ex1 ex2) = [aplica op x1 x2 | 
                            x1 <-valor ex1 ,
                            x2 <-valor ex2 , 
                            valida op x1 x2]