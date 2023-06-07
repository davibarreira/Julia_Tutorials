type Algebra f a = f a -> a
data ListF c a = NilF | ConsF c a
data List c = Nil | Cons c (List c)

phi :: ListF c (List c) -> List c
phi NilF = Nil
phi (ConsF c lst) = Cons c lst

evalSum :: Algebra (ListF Int) Int
evalSum (ConsF n x) = n + x
evalSum NilF = 0

cataSum :: List Int -> Int
cataSum Nil = evalSum NilF
cataSum (Cons n ns) = evalSum (ConsF n (cataSum ns))


--
-- Run ---
-- evalSum(ConsF 10 10)
-- evalSum(NilF)
-- cataSum(Cons 10 (Cons 20 Nil))
