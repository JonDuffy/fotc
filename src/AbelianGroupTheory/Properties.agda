------------------------------------------------------------------------------
-- Abelian group theory properties
------------------------------------------------------------------------------

module AbelianGroupTheory.Properties where

open import AbelianGroupTheory.Base

------------------------------------------------------------------------------

postulate
  xyx⁻¹≡y : ∀ a b → a ∙ b ∙ a ⁻¹ ≡ b
{-# ATP prove xyx⁻¹≡y #-}

postulate
  x⁻¹y⁻¹≡[xy]⁻¹ : ∀ a b → a ⁻¹ ∙ b ⁻¹ ≡ (a ∙ b) ⁻¹
{-# ATP prove x⁻¹y⁻¹≡[xy]⁻¹ #-}
