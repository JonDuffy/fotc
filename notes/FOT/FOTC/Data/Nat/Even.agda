------------------------------------------------------------------------------
-- Even predicate
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module FOT.FOTC.Data.Nat.Even where

open import FOTC.Base

------------------------------------------------------------------------------

data Even : D → Set where
  ezero :                  Even zero
  enext : ∀ {n} → Even n → Even (succ₁ (succ₁ n))

Even-ind : (A : D → Set) →
           A zero →
           (∀ {n} → A n → A (succ₁ (succ₁ n))) →
           ∀ {n} → Even n → A n
Even-ind A A0 h ezero      = A0
Even-ind A A0 h (enext En) = h (Even-ind A A0 h En)
