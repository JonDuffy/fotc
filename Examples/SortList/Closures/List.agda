------------------------------------------------------------------------------
-- Closures properties respect to List
------------------------------------------------------------------------------

module Examples.SortList.Closures.List where

open import LTC.Minimal
open import LTC.MinimalER

open import Examples.SortList.SortList

open import LTC.Data.Nat.List.Type
open import LTC.Data.Nat.List.Properties using ( ++-ListN )

------------------------------------------------------------------------------

-- The function flatten generates a list.
flatten-List : {t : D} → Tree t → ListN (flatten t)
flatten-List nilT = prf
  where
    postulate prf : ListN (flatten nilTree)
    {-# ATP prove prf #-}
flatten-List (tipT {i} Ni) = prf
  where
    postulate prf : ListN (flatten (tip i))
    {-# ATP prove prf #-}

flatten-List (nodeT {t₁} {i} {t₂} Tt₁ Ni Tt₂) =
  prf (flatten-List Tt₁) (flatten-List Tt₂)
  where
    postulate prf : ListN (flatten t₁) → -- IH.
                    ListN (flatten t₂) → -- IH.
                    ListN (flatten (node t₁ i t₂))
