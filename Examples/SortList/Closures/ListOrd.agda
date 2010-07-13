------------------------------------------------------------------------------
-- Closures properties respect to ListOrd
------------------------------------------------------------------------------

module Examples.SortList.Closures.ListOrd where

open import LTC.Minimal

open import Examples.SortList.Closures.Bool
  using ( ≤-ItemList-Bool ; ≤-Lists-Bool ; isListOrd-Bool)
open import Examples.SortList.Closures.List using ( flatten-List )
open import Examples.SortList.Closures.TreeOrd
  using ( leftSubTree-TreeOrd ; rightSubTree-TreeOrd )
open import Examples.SortList.Properties using ( subList-ListOrd ; xs≤[] )
open import Examples.SortList.SortList

open import LTC.Data.Bool.Properties
  using ( ≤-Bool ; x&&y≡true→x≡true ; x&&y≡true→y≡true )
open import LTC.Data.Nat.List.Type
open import LTC.Data.Nat.Type
open import LTC.Data.List

open import Postulates using ( ++-ListOrd-aux₁ )

------------------------------------------------------------------------------
-- Auxiliar functions

++-ListOrd-aux₂ : {item is js : D} → N item → ListN is → ListN js →
                  LE-ItemList item is →
                  LE-Lists is js →
                  LE-ItemList item (is ++ js)
++-ListOrd-aux₂ {item} {js = js} Nitem nilLN LNjs item≤niL niL≤js = prf
  where
    postulate prf : LE-ItemList item ([] ++ js)
    {-# ATP prove prf ++-ListOrd-aux₁ #-}

++-ListOrd-aux₂ {item} {js = js} Nitem
               (consLN {i} {is} Ni LNis) LNjs item≤i∷is i∷is≤js =
  prf (++-ListOrd-aux₂ Nitem LNis LNjs
        (x&&y≡true→y≡true (≤-Bool Nitem Ni)
                          (≤-ItemList-Bool Nitem LNis)
                          (trans (sym (≤-ItemList-∷ item i is)) item≤i∷is))
        (x&&y≡true→y≡true (≤-ItemList-Bool Ni LNis)
                          (≤-Lists-Bool LNis LNjs)
                          (trans (sym (≤-Lists-∷ i is js)) i∷is≤js)))
  where
    postulate prf : LE-ItemList item (is ++ js) → -- IH.
                    LE-ItemList item ((i ∷ is) ++ js)
    {-# ATP prove prf ≤-Bool ≤-ItemList-Bool x&&y≡true→x≡true #-}

------------------------------------------------------------------------------
-- Append preserves the order.
++-ListOrd : {is js : D} → ListN is → ListN js → ListOrd is → ListOrd js →
             LE-Lists is js →
             ListOrd (is ++ js)

++-ListOrd {js = js} nilLN LNjs LOis LOjs is≤js = prf
  where
    postulate prf : ListOrd ([] ++ js)
    {-# ATP prove prf #-}

++-ListOrd {js = js} (consLN {i} {is} Ni LNis) LNjs LOi∷is LOjs i∷is≤js =
  prf (++-ListOrd LNis LNjs (subList-ListOrd Ni LNis LOi∷is) LOjs
                  (x&&y≡true→y≡true
                    (≤-ItemList-Bool Ni LNis)
                    (≤-Lists-Bool LNis LNjs)
                    (trans (sym (≤-Lists-∷ i is js)) i∷is≤js)))
  where
    postulate prf : ListOrd (is ++ js) → -- IH.
                    ListOrd ((i ∷ is) ++ js)
    {-# ATP prove prf ≤-ItemList-Bool ≤-Lists-Bool
                      x&&y≡true→x≡true x&&y≡true→y≡true
                      ++-ListOrd-aux₂
    #-}

------------------------------------------------------------------------------
mutual
  -- If t is ordered then (flatten t) is ordered
  flatten-ListOrd : {t : D} → Tree t → TreeOrd t → ListOrd (flatten t)
  flatten-ListOrd nilT TOnilT = prf
    where
      postulate prf : ListOrd (flatten nilTree)
      {-# ATP prove prf #-}

  flatten-ListOrd (tipT {i} Ni ) TOtipT = prf
    where
      postulate prf : ListOrd (flatten (tip i))
      {-# ATP prove prf #-}

  flatten-ListOrd (nodeT {t₁} {i} {t₂} Tt₁ Ni Tt₂ ) TOnodeT =
    prf (flatten-ListOrd Tt₁ (leftSubTree-TreeOrd Tt₁ Ni Tt₂ TOnodeT))
        (flatten-ListOrd Tt₂ (rightSubTree-TreeOrd Tt₁ Ni Tt₂ TOnodeT))
        (flatten-ListOrd-aux Tt₁ Ni Tt₂ TOnodeT)
    where
      postulate prf : ListOrd (flatten t₁) → -- IH.
                      ListOrd (flatten t₂) → -- IH.
                      LE-Lists (flatten t₁) (flatten t₂) →
                      ListOrd (flatten (node t₁ i t₂))
      {-# ATP prove prf ++-ListOrd flatten-List
                  leftSubTree-TreeOrd rightSubTree-TreeOrd
      #-}

  flatten-ListOrd-aux : {t₁ i t₂ : D} → Tree t₁ → N i →
                        Tree t₂ → TreeOrd (node t₁ i t₂) →
                        LE-Lists (flatten t₁) (flatten t₂)
  flatten-ListOrd-aux {t₂ = t₂} nilT Niaux Tt₂ _ = prf
    where
      postulate prf : LE-Lists (flatten nilTree) (flatten t₂)
      {-# ATP prove prf #-}

  flatten-ListOrd-aux (tipT {j} Nj) Ni nilT TOnode = prf
    where
      postulate prf : LE-Lists (flatten (tip j)) (flatten nilTree)
      {-# ATP prove prf #-}

  flatten-ListOrd-aux (tipT {j} Nj) Ni (tipT {k} Nk) TOnode = prf
    where
      postulate prf : LE-Lists (flatten (tip j)) (flatten (tip k))
      {-# ATP prove prf #-}

  flatten-ListOrd-aux (tipT {j} Nj) Ni (nodeT {ta} {k} {tb} Tta Nk Ttb )
                      TOnode = prf
    where
      postulate prf : LE-Lists (flatten (tip j)) (flatten (node ta k tb))
      {-# ATP prove prf #-}

  flatten-ListOrd-aux (nodeT {ta} {j} {tb} Tta Nj Ttb) Ni nilT TOnode =
    prf (flatten-List (nodeT Tta Nj Ttb))
        (flatten-ListOrd (nodeT Tta Nj Ttb)
        (leftSubTree-TreeOrd (nodeT Tta Nj Ttb) Ni nilT TOnode))
    where
      postulate prf : ListN (flatten (node ta j tb)) →
                      ListOrd (flatten (node ta j tb)) → -- mutual IH.
                      LE-Lists (flatten (node ta j tb)) (flatten nilTree)
      {-# ATP prove prf xs≤[] #-}

  flatten-ListOrd-aux (nodeT {ta} {j} {tb} Tta Nj Ttb)
                      Ni
                      (tipT {k} Nk)
                      TOnode = prf
    where
      postulate prf : LE-Lists (flatten (node ta j tb)) (flatten (tip k))
      {-# ATP prove prf #-}

  flatten-ListOrd-aux (nodeT {ta} {j} {tb} Tta Nj Ttb)
                      Ni
                      (nodeT {tc} {k} {td} Ttc Nk Ttd)
                      TOnode = prf
    where
      postulate prf : LE-Lists (flatten (node ta j tb))
                                (flatten (node tc k td))
