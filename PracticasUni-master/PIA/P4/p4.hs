

type Racional1 = (Integer,Integer)

simplificaRac :: Racional1 -> Racional1
simplificaRac (n,d) = (sn,sd) where
    mcd = gcd n d 
    sd = abs (div d mcd)
    sn = (signum n) * (signum d) * abs (div n mcd)  

multRac :: Racional1 -> Racional1 ->Racional1
multRac (n,d) (n2,d2) = simplificaRac(n*n2,d*d2) 

divRac :: Racional1 -> Racional1 ->Racional1
divRac (n,d) (n2,d2) = simplificaRac(n*d2,d*n2) 

sumRac :: Racional1 -> Racional1 -> Racional1
sumRac (n1,d1) (n2,d2) = simplificaRac(sn1 + sn2,mcm) where
    mcm = lcm d1 d2 
    sn1 =  n1 * mcm `div` d1 
    sn2 =  n2 * mcm `div` d2 

resRac :: Racional1 -> Racional1 -> Racional1
resRac (n1,d1) (n2,d2) = simplificaRac(sn1 - sn2,mcm) where
    mcm = lcm d1 d2 
    sn1 =  n1 * mcm `div` d1 
    sn2 =  n2 * mcm `div` d2 

muestraRac1 :: Racional1 -> String
muestraRac1 (n,d) 
    |  d' == 1 = show n'
    |  otherwise = show n' ++ "/" ++ show d' 
    where (n',d') = simplificaRac(n,d)

data Racional2 =  Rac Integer Integer
    deriving Eq

conviRac2_1 :: Racional2 -> Racional1
conviRac2_1 (Rac n d) = (n,d)

conviRac1_2 :: Racional1 -> Racional2
conviRac1_2 (n,d) = (Rac n d)

simplificar2 :: Racional2 -> Racional2
simplificar2 (Rac n d) = (Rac (((signum d)*n) `div` m)  ((abs d) `div`m))
    where m = gcd n d

r2Mul :: Racional2 -> Racional2 -> Racional2
r2Mul (Rac n1 d1) (Rac n2 d2) = simplificar2 (Rac (n1*n2) (d1*d2))

r2Div :: Racional2 -> Racional2 -> Racional2
r2Div (Rac n1 d1) (Rac n2 d2) = simplificar2 (Rac (n1*d2) (d1*n2)) 

r2Sum :: Racional2 -> Racional2 -> Racional2
r2Sum (Rac n1 d1) (Rac n2 d2) = simplificar2 (Rac (n1*d2+n2*d1) (d1*d2)) 

r2Res :: Racional2 -> Racional2 -> Racional2
r2Res (Rac n1 d1) (Rac n2 d2) = simplificar2 (Rac (n1*d2-n2*d1) (d1*d2)) 

instance Show Racional2 where 
    show (Rac n 1) = show n
    show (Rac n d) = show n' ++ "/" ++ show d' where
        (n',d') =  simplificaRac(n,d) 


instance Num Racional2 where
    (+) = r2Sum 
    (-) = r2Res
    (*) = r2Mul
    