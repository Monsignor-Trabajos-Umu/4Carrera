module Pila(Pila,vacia,apila,cima,desapila,esVacia) where


data Pila a = P [a]

-- A es de tipo show
instance (Show a) => Show (Pila a) where
    show (P []) = show "-"
    show (P (x:xs)) = show x ++ "|" ++ show (P xs)
-- Definicir funcion vacia
vacia ::  Pila a
vacia = P []

-- (e)(0.5 puntos)Definir la funcion apila x p, que devuelva la pila obtenida añadiendo x encima de la pila p.
apila :: a -> Pila a -> Pila a
apila x (P xs) = P(x:xs)
--(f)(0.5 puntos)Definir la funcion cima p que devuelva la cima de la pila p
cima :: Pila a -> a
cima (P (x:_)) = x
cima (P []) = error "La pila esta vacia"

-- (g)(0.5 puntos)Definir la funcion desapila p que devuelva la pila obtenida suprimiendo la cima de la pila p.
desapila :: Pila a -> Pila a
desapila (P(_:xs)) = P xs
desapila (P []) = error "La pila esta vacia"

-- esVacia 
esVacia  :: Pila a -> Bool
esVacia  (P []) = True 
esVacia (P (_:_)) = False 
