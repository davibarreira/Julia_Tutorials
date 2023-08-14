{-# LANGUAGE FlexibleInstances #-}
data Free f a = Pure a | Free (f (Free f a))
--it needs to be a functor
instance Functor f => Functor (Free f) where
  fmap f (Pure a) = Pure (f a)
  fmap f (Free x) = Free (fmap (fmap f) x)

instance Functor f => Applicative (Free f) where
    pure = Pure
    Pure g <*> Pure a = Pure (g a)
    Pure g <*> Free fa = Free (fmap (g <$>) fa)

--this is the same thing as (++) basically
concatFree :: Functor f => Free f (Free f a) -> Free f a
concatFree (Pure x) = x
concatFree (Free y) = Free (fmap concatFree y)

instance Functor f => Monad (Free f) where
  return = Pure -- just like []
  x >>= f = concatFree (fmap f x)

-- this is essentially the same as \x -> [x]
liftFree :: Functor f => f a -> Free f a
liftFree x = Free (fmap Pure x)

-- this is essentially the same as folding a list
foldFree :: Functor f => (f r -> r) -> Free f r -> r
foldFree _ (Pure a) = a
foldFree f (Free x) = f (fmap (foldFree f) x)

data F a = One a | Two a a | Two' a a | Three Int a a a
  deriving Show

-- Lift F into the Free monad
type FreeF a = Free F a

tree :: FreeF String
tree = Free (One (Pure "A"))

example1 :: F (FreeF String)
example1 = One (Free (One (Pure "A")))

instance Show a => Show (Free F a) where
  show (Pure a) = "Pure " ++ show a
  show (Free x) = "Free (" ++ show x ++ ")"

-- result :: FreeF (FreeF String)
-- result = Free (One (Free (One (Pure "A"))))
result :: F (FreeF Int)
result = One (Free (One (Pure 1)))
