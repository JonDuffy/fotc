------------------------------------------------------------------------------
-- Abelian group theory properties
------------------------------------------------------------------------------

{-# OPTIONS --exact-split              #-}
{-# OPTIONS --no-sized-types           #-}
{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K                #-}

module GroupTheory.AbelianGroup.PropertiesATP where

open import GroupTheory.AbelianGroup.Base

------------------------------------------------------------------------------

postulate xyx⁻¹≡y : ∀ a b → a · b · a ⁻¹ ≡ b
{-# ATP prove xyx⁻¹≡y #-}

postulate x⁻¹y⁻¹≡[xy]⁻¹ : ∀ a b → a ⁻¹ · b ⁻¹ ≡ (a · b) ⁻¹
{-# ATP prove x⁻¹y⁻¹≡[xy]⁻¹ #-}
