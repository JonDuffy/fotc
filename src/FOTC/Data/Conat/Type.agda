------------------------------------------------------------------------------
-- The FOTC coinductive natural numbers type
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

-- Adapted from: Herbert P. Sander. A logic of functional programs
-- with an application to concurrency. PhD thesis, Chalmers University
-- of Technology and University of Gothenburg, Department of Computer
-- Sciences, 1992.

module FOTC.Data.Conat.Type where

open import FOTC.Base

------------------------------------------------------------------------------

-- Functional for the FOTC coinductive natural numbers type.
-- ConatF : (D → Set) → D → Set
-- ConatF P n = ∃[ n' ] P n' ∧ n = succ n'

-- Conat is the greatest post-fixed of ConatF (by Conat-gfp₁ and Conat-gfp₂).

postulate
  Conat : D → Set

-- Conat is post-fixed point of ConatF (d ≤ f d).
postulate
  Conat-gfp₁ : ∀ {n} → Conat n → ∃[ n' ] Conat n' ∧ n ≡ succ₁ n'
{-# ATP axiom Conat-gfp₁ #-}

-- ∀ e. e ≤ f e => e ≤ d.
--
-- N.B. This is an axiom schema. Because in the automatic proofs we
-- *must* use an instance, we do not add this postulate as an ATP
-- axiom.
postulate
  Conat-gfp₂ : (P : D → Set) →
               -- P is post-fixed point of ConatF.
               (∀ {n} → P n → ∃[ n' ] P n' ∧ n ≡ succ₁ n') →
               -- Conat is greater than P.
               ∀ {n} → P n → Conat n

-- Because a greatest post-fixed point is a fixed point, then the
-- Conat predicate is also a pre-fixed point of the functor ConatF
-- (f d ≤ d).
Conat-gfp₃ : ∀ {n} →
             (∃[ n' ] Conat n' ∧ n ≡ succ₁ n') →
             Conat n
Conat-gfp₃ h = Conat-gfp₂ P helper h
  where
  P : D → Set
  P m = ∃[ m' ] Conat m' ∧ m ≡ succ₁ m'

  helper : ∀ {n} → P n → ∃[ n' ] P n' ∧ n ≡ succ₁ n'
  helper (∃-intro (CNn' , n≡Sn')) = ∃-intro (Conat-gfp₁ CNn' , n≡Sn')
