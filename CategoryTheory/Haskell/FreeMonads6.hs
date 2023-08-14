{-# LANGUAGE DeriveFunctor #-}

data Free f a
  = Pure a
  | Free (f (Free f a))

instance Functor f => Functor (Free f) where
  fmap f (Pure a) = Pure (f a)
  fmap f (Free x) = Free (fmap f <$> x)

instance Functor f => Applicative (Free f) where
  pure = Pure
  Pure f <*> Pure a = Pure (f a)
  Pure f <*> Free x = Free (fmap f <$> x)
  Free x <*> my     = Free ((<*> my) <$> x)

instance Functor f => Monad (Free f) where
  return = pure
  Pure a >>= f = f a
  Free x >>= f = Free ((>>= f) <$> x)

data Terminal a
  = GetLine (String -> a)
  | PrintLine String a
  deriving Functor
