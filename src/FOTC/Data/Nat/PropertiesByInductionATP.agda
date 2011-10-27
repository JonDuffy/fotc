------------------------------------------------------------------------------
-- Arithmetic properties (using induction on the FOTC natural numbers type)
------------------------------------------------------------------------------

-- Usually our proofs use pattern matching instead of the induction
-- principle associated with the FOTC natural numbers. The following
-- examples show some proofs using it.

-- TODO: We have not tested which ATPs fail on the ATP conjectures.

module FOTC.Data.Nat.PropertiesByInductionATP where

open import FOTC.Base

open import FOTC.Data.Nat

------------------------------------------------------------------------------

+-leftIdentity : ∀ {n} → N n → zero + n ≡ n
+-leftIdentity {n} Nn = +-0x n

-- The predicate is not inside the where clause because the
-- translation of projection-like functions is not implemented.
+-rightIdentity-P : D → Set
+-rightIdentity-P i = i + zero ≡ i
{-# ATP definition +-rightIdentity-P #-}

+-rightIdentity : ∀ {n} → N n → n + zero ≡ n
+-rightIdentity Nn = indN +-rightIdentity-P P0 is Nn
  where
  postulate P0 : +-rightIdentity-P zero
  {-# ATP prove P0 #-}

  postulate is : ∀ {i} → N i →
                 +-rightIdentity-P i → +-rightIdentity-P (succ₁ i)
  {-# ATP prove is #-}

+-N : ∀ {m n} → N m → N n → N (m + n)
+-N {n = n} Nm Nn = indN P P0 is Nm
  where
  P : D → Set
  P i = N (i + n)
  {-# ATP definition P #-}

  postulate P0 : P zero
  {-# ATP prove P0 #-}

  postulate is : ∀ {i} → N i → P i → P (succ₁ i)
  {-# ATP prove is #-}

+-assoc : ∀ {m n o} → N m → N n → N o → m + n + o ≡ m + (n + o)
+-assoc {n = n} {o} Nm Nn No = indN P P0 is Nm
  where
  P : D → Set
  P i = i + n + o ≡ i + (n + o)
  {-# ATP definition P #-}

  postulate P0 : P zero
  {-# ATP prove P0 #-}

  postulate is : ∀ {i} → N i → P i → P (succ₁ i)
  {-# ATP prove is #-}

-- A proof without use ATPs definitions.
+-assoc' : ∀ {m n o} → N m → N n → N o → m + n + o ≡ m + (n + o)
+-assoc' {n = n} {o} Nm Nn No = indN P P0 is Nm
  where
  P : D → Set
  P i = i + n + o ≡ i + (n + o)

  postulate P0 : zero + n + o ≡ zero + (n + o)
  {-# ATP prove P0 #-}

  postulate
    is : ∀ {i} → N i →
         i + n + o ≡ i + (n + o) →  -- IH.
         succ₁ i + n + o ≡ succ₁ i + (n + o)
  {-# ATP prove is #-}

x+Sy≡S[x+y] : ∀ {m n} → N m → N n → m + succ₁ n ≡ succ₁ (m + n)
x+Sy≡S[x+y] {n = n} Nm Nn = indN P P0 is Nm
  where
  P : D → Set
  P i = i + succ₁ n ≡ succ₁ (i + n)
  {-# ATP definition P #-}

  postulate P0 : P zero
  {-# ATP prove P0 #-}

  postulate is : ∀ {i} → N i → P i → P (succ₁ i)
  {-# ATP prove is #-}

+-comm : ∀ {m n} → N m → N n → m + n ≡ n + m
+-comm {n = n} Nm Nn = indN P P0 is Nm
  where
  P : D → Set
  P i = i + n ≡ n + i
  {-# ATP definition P #-}

  postulate P0 : P zero
  {-# ATP prove P0 +-rightIdentity #-}

  postulate is : ∀ {i} → N i → P i → P (succ₁ i)
  {-# ATP prove is x+Sy≡S[x+y] #-}
