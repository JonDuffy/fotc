------------------------------------------------------------------------------
-- Streams properties
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
-- {-# OPTIONS --without-K #-}

module FOTC.Data.Stream.PropertiesI where

open import FOTC.Base
open FOTC.Base.BList
open import FOTC.Base.PropertiesI
open import FOTC.Data.Conat
open import FOTC.Data.Conat.Equality
open import FOTC.Data.List
open import FOTC.Data.Stream
open import FOTC.Relation.Binary.Bisimilarity

-----------------------------------------------------------------------------

tailS : ∀ {x xs} → Stream (x ∷ xs) → Stream xs
tailS {x} {xs} h with (Stream-unf h)
... | x' , xs' , Sxs' , h₁ = subst Stream (sym (∧-proj₂ (∷-injective h₁))) Sxs'

≈→Stream : ∀ {xs ys} → xs ≈ ys → Stream xs ∧ Stream ys
≈→Stream {xs} {ys} h = Stream-coind P₁ h₁ (ys , h) , Stream-coind P₂ h₂ (xs , h)
  where
  P₁ : D → Set
  P₁ ws = ∃[ zs ] ws ≈ zs

  h₁ : ∀ {ws} → P₁ ws → ∃[ w' ] ∃[ ws' ] P₁ ws' ∧ ws ≡ w' ∷ ws'
  h₁ {ws} (zs , h₁) with ≈-unf h₁
  ... | w' , ws' , zs' , prf₁ , prf₂ , _ = w' , ws' , (zs' , prf₁) , prf₂

  P₂ : D → Set
  P₂ zs = ∃[ ws ] ws ≈ zs

  h₂ : ∀ {zs} → P₂ zs → ∃[ z' ] ∃[ zs' ] P₂ zs' ∧ zs ≡ z' ∷ zs'
  h₂  {zs} (ws , h₁) with ≈-unf h₁
  ... | w' , ws' , zs' , prf₁ , _ , prf₂ = w' , zs' , (ws' , prf₁) , prf₂

-- Requires K.
lengthStream : ∀ {xs} → Stream xs → length xs ≈N ∞
lengthStream {xs} Sxs = ≈N-coind _R_ h₁ h₂
  where
  _R_ : D → D → Set
  m R n = ∃[ xs ] Stream xs ∧ m ≡ length xs ∧ n ≡ ∞

  h₁ : ∀ {m n} → m R n →
       m ≡ zero ∧ n ≡ zero ∨
       (∃[ m' ] ∃[ n' ] m' R n' ∧ m ≡ succ₁ m' ∧ n ≡ succ₁ n')
  h₁ (_ , Sxs' , _ ) with Stream-unf Sxs'
  h₁ (.(x'' ∷ xs'') , Sxs' , m≡length-x''∷xs'' , n≡∞)
     | x'' , xs'' , Sxs'' , refl =
    inj₂ (length xs'' , ∞ , (xs'' , Sxs'' , refl , refl)
         , trans m≡length-x''∷xs'' (length-∷ x'' xs'') , trans n≡∞ ∞-eq
         )

  h₂ : length xs R ∞
  h₂ = xs , Sxs , refl , refl
