data M a = Nil | J a
  deriving (Show)

-- data F a = Nil | J a
--   deriving (Show)

-- checkType :: M a -> Bool
-- checkType Nil = False
-- checkType (J _) = True
checkNilType :: M Int -> String
checkNilType Nil = "Nil is of type M Int"
checkNilType _   = "Nil is not of type M Int"

