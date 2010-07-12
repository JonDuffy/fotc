------------------------------------------------------------------------------
-- Closures properties respect to Tree
------------------------------------------------------------------------------

module Examples.SortList.Closures.Tree where

open import LTC.Minimal

open import Examples.SortList.SortList

open import LTC.Data.Nat.Inequalities
open import LTC.Data.Nat.Inequalities.Properties using ( x>y∨x≤y ; x>y→x≰y )
open import LTC.Data.Nat.Type
open import LTC.Data.Nat.List

------------------------------------------------------------------------------

toTree-Tree : {item : D}{t : D} → N item → Tree t → Tree (toTree ∙ item ∙ t)
toTree-Tree {item} Nitem nilT = prf
  where
    postulate prf : Tree (toTree ∙ item ∙ nilTree)
    {-# ATP prove prf #-}

toTree-Tree {item} Nitem (tipT {i} Ni ) = prf (x>y∨x≤y Ni Nitem)
  where
    postulate prf : GT i item ∨ LE i item → Tree (toTree ∙ item ∙ tip i)
    {-# ATP prove prf x>y→x≰y #-}
toTree-Tree {item} Nitem (nodeT {t₁} {i} {t₂} Tt₁ Ni Tt₂ ) =
  prf (x>y∨x≤y Ni Nitem) (toTree-Tree Nitem Tt₁) ((toTree-Tree Nitem Tt₂))
  where
    postulate prf : GT i item ∨ LE i item →
                    Tree (toTree ∙ item ∙ t₁) → -- IH.
                    Tree (toTree ∙ item ∙ t₂) → -- IH.
                    Tree (toTree ∙ item ∙ node t₁ i t₂)
    {-# ATP prove prf x>y→x≰y #-}

makeTree-Tree : {is : D} → List is → Tree (makeTree is)
makeTree-Tree nilL = prf
  where
    postulate prf : Tree (makeTree [])
    {-# ATP prove prf #-}

makeTree-Tree (consL {n} {ns} Nn Nns Lns) = prf (makeTree-Tree Lns)
  where
    postulate prf : Tree (makeTree ns) → -- IH.
                    Tree (makeTree (n ∷ ns))
    {-# ATP prove prf toTree-Tree #-}
