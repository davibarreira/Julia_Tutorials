{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE DeriveFunctor #-}


data Free f a = Pure a | Free (f (Free f a))

instance (Show (f (Free f a)), Show a) => Show (Free f a) where
    show (Pure a) = "Pure " ++ show a
    show (Free fa) = "Free (" ++ show fa ++ ")"


instance Functor f => Functor (Free f) where
    fmap g (Pure a) = Pure (g a)
    fmap g (Free fa) = Free (fmap (fmap g) fa)

instance Functor f => Applicative (Free f) where
    pure = Pure
    Pure g <*> Pure a = Pure (g a)
    Pure g <*> Free fa = Free (fmap (g <$>) fa)
    Free fg <*> x = Free ((<*> x) <$> fg)

instance Functor f => Monad (Free f) where
  return = Pure
  Pure x >>= f = f x
  Free g >>= f = Free ((>>= f) <$> g)

liftF :: Functor f => f a -> Free f a
liftF cmd = Free (fmap Pure cmd)

data F a = Add Double a | Mult Double a | Nil deriving (Show)

instance Functor F where
    fmap _ Nil = Nil
    fmap f (Add r x) = Add r (f x)
    fmap f (Mult r x) = Mult r (f x)

example :: Free Maybe Int
example = Free (Just (Pure 42))

exampleAdd :: Free F Int
exampleAdd = liftF (Add 5 10) >>= (\_ -> liftF (Add 3 7) >>= (\_ -> liftF Nil))

-- fmap (\x->x+1) exampleAdd
exampleCombo :: Free F Int
exampleCombo = do
  liftF (Add 10 7)
  liftF (Mult 2 3)
  liftF (Add 5 4)
  liftF Nil



-- | Key value store functionality.
data KeyValF a
  = GetKey String (Maybe String -> a)
  | PutKey String String a
  deriving (Functor)

-- | Console functionality.
data ConsoleF a
  = PutStrLn String a
  | GetLine (String -> a)
  deriving (Functor)
type Console = Free ConsoleF
type KeyVal = Free KeyValF

getKey :: String -> KeyVal (Maybe String)
getKey k = liftF (GetKey k id)

putStrLn :: String -> Console ()
putStrLn s = liftF (PutStrLn s ())

getLine :: Console String
getLine = liftF (GetLine id)
