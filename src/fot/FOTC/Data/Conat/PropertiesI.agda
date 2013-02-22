------------------------------------------------------------------------------
-- Conat properties
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

-- References:
--
-- • Herbert P. Sander. A logic of functional programs with an
--   application to concurrency. PhD thesis, Chalmers University of
--   Technology and University of Gothenburg, Department of Computer
--   Sciences, 1992.

module FOTC.Data.Conat.PropertiesI where

open import FOTC.Base
open import FOTC.Data.Conat
open import FOTC.Data.Nat

------------------------------------------------------------------------------

0-Conat : Conat zero
0-Conat = Conat-coind P prf refl
  where
  P : D → Set
  P n = n ≡ zero

  prf : ∀ {n} → P n → n ≡ zero ∨ (∃[ n' ] P n' ∧ n ≡ succ₁ n')
  prf Pn = inj₁ Pn

-- Adapted from (Sander 1992, p. 57).
∞N-Conat : Conat ∞N
∞N-Conat = Conat-coind P prf refl
  where
  P : D → Set
  P n = n ≡ ∞N

  prf : ∀ {n} → P n → n ≡ zero ∨ (∃[ n' ] P n' ∧ n ≡ succ₁ n')
  prf Pn = inj₂ (∞N , refl , trans Pn ∞N-eq)

N→Conat : ∀ {n} → N n → Conat n
N→Conat Nn = Conat-coind N prf Nn
  where
  prf : ∀ {m} → N m → m ≡ zero ∨ (∃[ m' ] N m' ∧ m ≡ succ₁ m')
  prf nzero          = inj₁ refl
  prf (nsucc {m} Nm) = inj₂ (m , Nm , refl)

-- A different proof.
N→Conat₁ : ∀ {n} → N n → Conat n
N→Conat₁ nzero          = Conat-pre-fixed (inj₁ refl)
N→Conat₁ (nsucc {n} Nn) = Conat-pre-fixed (inj₂ (n , (N→Conat Nn , refl)))
