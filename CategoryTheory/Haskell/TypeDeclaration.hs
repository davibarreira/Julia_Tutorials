data M a = Nil | J a
data F a = Nil | J a

checkType :: M a -> Bool
checkType Nil = False
checkType (J _) = True
