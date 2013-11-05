------------------------------------------------------------------------------
-- Streams properties
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

-- References:
--
-- • Sander, Herbert P. (1992). A Logic of Functional Programs with an
--   Application to Concurrency. PhD thesis. Department of Computer
--   Sciences: Chalmers University of Technology and University of
--   Gothenburg.

module FOTC.Data.Stream.PropertiesATP where

open import FOTC.Base
open import FOTC.Base.List
open import FOTC.Data.Conat
open import FOTC.Data.Conat.Equality
open import FOTC.Data.List
open import FOTC.Data.Stream

------------------------------------------------------------------------------

postulate tailS : ∀ {x xs} → Stream (x ∷ xs) → Stream xs
{-# ATP prove tailS #-}

-- Adapted from (Sander 1992, p. 58).
streamLength : ∀ {xs} → Stream xs → length xs ≈N ∞
streamLength {xs} Sxs = ≈N-coind R h₁ h₂
  where
  R : D → D → Set
  R m n = m ≡ zero ∧ n ≡ zero ∨ (∃[ xs' ] m ≡ length xs' ∧ n ≡ ∞ ∧ Stream xs')
  {-# ATP definition R #-}

  postulate
    h₁ : ∀ {m n} → R m n →
         m ≡ zero ∧ n ≡ zero
           ∨ (∃[ m' ] ∃[ n' ] m ≡ succ₁ m' ∧ n ≡ succ₁ n' ∧ R m' n')
  {-# ATP prove h₁ #-}

  postulate h₂ : R (length xs) ∞
  {-# ATP prove h₂ #-}
