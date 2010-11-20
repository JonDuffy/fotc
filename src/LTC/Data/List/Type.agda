------------------------------------------------------------------------------
-- The LTC list type
------------------------------------------------------------------------------

module LTC.Data.List.Type where

open import LTC.Base

------------------------------------------------------------------------------
-- The LTC list type.
data List : D → Set where
  nilL  : List []
  consL : (x : D){xs : D}(Lxs : List xs) → List (x ∷ xs)

-- Induction principle for List.
indList : (P : D → Set) →
          P [] →
          ((x : D){xs : D} → List xs → P xs → P (x ∷ xs)) →
          {xs : D} → List xs → P xs
indList P p[] iStep nilL          = p[]
indList P p[] iStep (consL x Lxs) = iStep x Lxs (indList P p[] iStep Lxs)
