------------------------------------------------------------------------------
-- Colist properties
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module FOTC.Data.Colist.PropertiesI where

open import FOTC.Base
open import FOTC.Base.List
open import FOTC.Data.Colist

------------------------------------------------------------------------------
-- Because a greatest post-fixed point is a fixed-point, then the
-- Colist predicate is also a pre-fixed point of the functional
-- ColistF, i.e.
--
-- ColistF Colist ≤ Colist (see FOTC.Data.Colist.Type).
Colist-pre-fixed : ∀ {xs} →
                   (xs ≡ [] ∨ (∃[ x' ] ∃[ xs' ] xs ≡ x' ∷ xs' ∧ Colist xs')) →
                   Colist xs
Colist-pre-fixed {xs} h = Colist-coind (λ ys → ys ≡ ys) h' refl
  where
  h' : xs ≡ xs → xs ≡ [] ∨ (∃[ x' ] ∃[ xs' ] xs ≡ x' ∷ xs' ∧ xs' ≡ xs')
  h' _ with h
  ... | inj₁ prf                        = inj₁ prf
  ... | inj₂ (x' , xs' , prf , _) = inj₂ (x' , xs' , prf , refl)