------------------------------------------------------------------------------
-- The alternating bit protocol (ABP) is correct
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

-- This module proves the correctness of the ABP following the
-- formalization in Dybjer and Sander (1989).
--
-- References:
--
-- • Dybjer, Peter and Sander, Herbert P. (1989). A Functional
--   Programming Approach to the Speciﬁcation and Veriﬁcation of
--   Concurrent Systems. In: Formal Aspects of Computing 1,
--   pp. 303–319.

module FOTC.Program.ABP.CorrectnessProofATP where

open import FOTC.Base
open import FOTC.Base.List
open import FOTC.Data.Stream
open import FOTC.Data.Stream.Equality.PropertiesATP
open import FOTC.Program.ABP.ABP
open import FOTC.Program.ABP.Fair
open import FOTC.Program.ABP.LemmaATP
open import FOTC.Program.ABP.Terms
open import FOTC.Relation.Binary.Bisimilarity

------------------------------------------------------------------------------
postulate
  helper :
    ∀ b i' is' os₁ os₂ →
    S b (i' ∷ is') os₁ os₂
      (has (send b) (ack b) (out b) (corrupt os₁) (corrupt os₂) (i' ∷ is'))
      (hbs (send b) (ack b) (out b) (corrupt os₁) (corrupt os₂) (i' ∷ is'))
      (hcs (send b) (ack b) (out b) (corrupt os₁) (corrupt os₂) (i' ∷ is'))
      (hds (send b) (ack b) (out b) (corrupt os₁) (corrupt os₂) (i' ∷ is'))
      (abpTransfer b os₁ os₂ (i' ∷ is'))
{-# ATP prove helper #-}

-- Main theorem.
abpCorrect : ∀ {b is os₁ os₂} → Bit b → Stream is → Fair os₁ → Fair os₂ →
             is ≈ abpTransfer b os₁ os₂ is
abpCorrect {b} {is} {os₁} {os₂} Bb Sis Fos₁ Fos₂ = ≈-coind B h refl
  where
  B : D → D → Set
  B xs ys = xs ≡ xs
  {-# ATP definition B #-}

  postulate
    h : B is (abpTransfer b os₁ os₂ is) →
        ∃[ i' ] ∃[ is' ] ∃[ js' ]
          is ≡ i' ∷ is' ∧ abpTransfer b os₁ os₂ is ≡ i' ∷ js' ∧ B is' js'
  {-# ATP prove h helper lemma #-}

------------------------------------------------------------------------------
-- abpTransfer produces a Stream.
postulate
  abp-Stream : ∀ {b is os₁ os₂} → Bit b → Stream is → Fair os₁ → Fair os₂ →
              Stream (abpTransfer b os₁ os₂ is)
{-# ATP prove abp-Stream ≈→Stream₂ abpCorrect #-}
