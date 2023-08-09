class Nearsemiring a where
  zero :: a
  one :: a
  (⊕) :: a -> a -> a
  (⊗) :: a -> a -> a

data Forest a = Forest [Tree a]
  deriving (Show)
data Tree a = Leaf | Node a (Forest a)
  deriving (Show)

instance Nearsemiring (Forest a) where
  zero = Forest []
  one = Forest [Leaf]
  (Forest xs) ⊕ (Forest ys) = Forest (xs ++ ys)
  (Forest xs) ⊗ (Forest ys) = Forest (concatMap g xs)
    where
      g Leaf = ys
      g (Node a n) = [Node a (n ⊗ Forest ys)]



example :: Forest Int
example = Forest [Node 1 (Forest [Leaf]), Node 2 (Forest [Leaf, Node 3 (Forest [Leaf])])]
