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

data FilesF a
  = FilesLs ([FilePath] -> a)
  | FilesMkdir FilePath a     -- équivalent à: FilesMkdir FilePath (() -> a)
  | FilesRmdir FilePath a
  deriving (Functor)

type Files = Free FilesF
