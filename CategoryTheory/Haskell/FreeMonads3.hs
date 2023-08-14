data Free f a = Pure a | Roll (f (Free f a))
--it needs to be a functor
instance Functor f => Functor (Free f) where
  fmap f (Pure a) = Pure (f a)
  fmap f (Roll x) = Roll (fmap (fmap f) x)

--this is the same thing as (++) basically
concatFree :: Functor f => Free f (Free f a) -> Free f a
concatFree (Pure x) = x
concatFree (Roll y) = Roll (fmap concatFree y)

data F a = One a | Two a a | Two' a a | Three Int a a a
  deriving Show

-- Lift F into the Free monad
type FreeF a = Free F a

tree :: FreeF String
tree = Roll (One (Pure "A"))

example1 :: F (FreeF String)
example1 = One (Roll (One (Pure "A")))

-- result :: FreeF (FreeF String)
-- result = Roll (One (Roll (One (Pure "A"))))
