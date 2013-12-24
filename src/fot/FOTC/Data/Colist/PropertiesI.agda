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
Colist-pre-fixed :
  ∀ {xs} →
  xs ≡ [] ∨ (∃[ x' ] ∃[ xs' ] xs ≡ x' ∷ xs' ∧ Colist xs') →
  Colist xs
Colist-pre-fixed h = Colist-coind A h' h
  where
  A : D → Set
  A xs =   xs ≡ [] ∨ (∃[ x' ] ∃[ xs' ] xs ≡ x' ∷ xs' ∧ Colist xs')

  h' : ∀ {xs} → A xs → xs ≡ [] ∨ (∃[ x' ] ∃[ xs' ] xs ≡ x' ∷ xs' ∧ A xs')
  h' (inj₁ xs≡[])                    = inj₁ xs≡[]
  h' (inj₂ (x' , xs' , prf , Clxs')) = inj₂ (x' , xs' , prf , Colist-unf Clxs')
