------------------------------------------------------------------------------
-- The map-iterate property: A property using coinduction
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

-- The map-iterate property (Gibbons and Hutton, 2005):
-- map f (iterate f x) = iterate f (f · x)

module FOTC.Program.MapIterate.MapIterateI where

open import Common.FOL.Relation.Binary.EqReasoning

open import FOTC.Base
open import FOTC.Base.List
open import FOTC.Data.List
open import FOTC.Data.List.PropertiesI
open import FOTC.Data.Stream
open import FOTC.Relation.Binary.Bisimilarity

------------------------------------------------------------------------------

unfoldMapIterate : ∀ f x →
                   map f (iterate f x) ≡ f · x ∷ map f (iterate f (f · x))
unfoldMapIterate f x =
  map f (iterate f x)               ≡⟨ mapCong₂ (iterate-eq f x) ⟩
  map f (x ∷ iterate f (f · x))     ≡⟨ map-∷ f x (iterate f (f · x)) ⟩
  f · x ∷ map f (iterate f (f · x)) ∎

map-iterate-Stream₁ : ∀ f x → Stream (map f (iterate f x))
map-iterate-Stream₁ f x = Stream-coind (λ xs → xs ≡ xs) h refl
  where
  h : map f (iterate f x) ≡ map f (iterate f x) →
      ∃[ x' ]  ∃[ xs' ] map f (iterate f x) ≡ x' ∷ xs' ∧ xs' ≡ xs'
  h _ = f · x , map f (iterate f (f · x)) , unfoldMapIterate f x , refl

map-iterate-Stream₂ : ∀ f x → Stream (iterate f (f · x))
map-iterate-Stream₂ f x = Stream-coind (λ xs → xs ≡ xs) h refl
  where
  h : iterate f (f · x) ≡ iterate f (f · x) →
      ∃[ x' ] ∃[ xs' ] iterate f (f · x) ≡ x' ∷ xs' ∧ xs' ≡ xs'
  h _ = f · x , iterate f (f · (f · x)) , iterate-eq f (f · x) , refl

-- The map-iterate property.
≈-map-iterate : ∀ f x → map f (iterate f x) ≈ iterate f (f · x)
≈-map-iterate f x = ≈-coind (λ xs _ → xs ≡ xs) h refl
  where
  h : map f (iterate f x) ≡ map f (iterate f x) →
      ∃[ x' ] ∃[ xs' ] ∃[ ys' ]
        map f (iterate f x) ≡ x' ∷ xs'
        ∧ iterate f (f · x) ≡ x' ∷ ys'
        ∧ xs' ≡ xs'
  h _ = f · x
        , map f (iterate f (f · x))
        , iterate f (f · (f · x))
        , unfoldMapIterate f x
        , iterate-eq f (f · x)
        , refl

------------------------------------------------------------------------------
-- References:

-- • Gibbons, Jeremy and Hutton, Graham (2005). Proof Methods for
--   Corecursive Programs. In: Fundamenta Informaticae XX, pp. 1–14.
