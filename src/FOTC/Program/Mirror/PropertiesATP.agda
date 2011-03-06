------------------------------------------------------------------------------
-- Properties of the mirror function
------------------------------------------------------------------------------

module FOTC.Program.Mirror.PropertiesATP where

open import FOTC.Base

open import FOTC.Data.List
open import FOTC.Data.List.PropertiesATP using ( reverse-[x]≡[x] )

open import FOTC.Program.Mirror.Mirror
open import FOTC.Program.Mirror.Forest.PropertiesATP
open import FOTC.Program.Mirror.Forest.Closures
open import FOTC.Program.Mirror.Tree.ClosuresATP
open import FOTC.Program.Mirror.Type

------------------------------------------------------------------------------

mutual
  mirror² : ∀ {t} → Tree t → mirror · (mirror · t) ≡ t
  mirror² (treeT d nilF) = prf
    where
      postulate prf : mirror · (mirror · node d []) ≡ node d []
      {-# ATP prove prf #-}

  mirror² (treeT d (consF {t} {ts} Tt Fts)) = prf
    where
      postulate prf : mirror · (mirror · node d (t ∷ ts)) ≡ node d (t ∷ ts)
      {-# ATP prove prf helper #-}

  helper : ∀ {ts} → Forest ts →
           reverse (map mirror (reverse (map mirror ts))) ≡ ts
  helper nilF = prf
    where
      postulate prf : reverse (map mirror (reverse (map mirror []))) ≡ []
      {-# ATP prove prf #-}

  helper (consF {t} {ts} Tt Fts) =
    prf (map-++-commute mirror
                        mirror-Tree
                        (reverse-Forest (map-Forest mirror mirror-Tree Fts))
                        (consF (mirror-Tree Tt) nilF))
        (mirror² Tt)
        (helper Fts)
    where
      postulate
        -- We help the ATPs proving the first hypothesis.
        prf : (map mirror (reverse (map mirror ts) ++ (mirror · t ∷ [])) ≡
              map mirror (reverse (map mirror ts)) ++ (map mirror (mirror · t ∷ []))) →
              mirror · (mirror · t) ≡ t →  -- IH.
              reverse (map mirror (reverse (map mirror ts))) ≡ ts →  -- IH.
              reverse (map mirror (reverse (map mirror (t ∷ ts)))) ≡ t ∷ ts
      {-# ATP prove prf reverse-∷ mirror-Tree map-Forest reverse-++-commute
                        reverse-Forest reverse-[x]≡[x] ++-leftIdentity #-}
