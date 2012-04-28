------------------------------------------------------------------------------
-- The LTC-PCF natural numbers type
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module Draft.FO-LTC-PCF.Data.Nat.Type where

open import Draft.FO-LTC-PCF.Base

------------------------------------------------------------------------------
-- The inductive predicate 'N' represents the type of the natural
-- numbers. They are a subset of 'D'.

-- The LTC-PCF natural numbers type.
data N : D → Set where
  zN :               N zero
  sN : ∀ {n} → N n → N (succ₁ n)
{-# ATP axiom zN sN #-}

-- Induction principle for N (elimination rule).
N-ind : (A : D → Set) →
       A zero →
       (∀ {n} → A n → A (succ₁ n)) →
       ∀ {n} → N n → A n
N-ind A A0 h zN      = A0
N-ind A A0 h (sN Nn) = h (N-ind A A0 h Nn)
