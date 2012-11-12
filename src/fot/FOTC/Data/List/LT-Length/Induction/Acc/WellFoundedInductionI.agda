------------------------------------------------------------------------------
-- Well-founded induction on the relation LTL
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module FOTC.Data.List.LT-Length.Induction.Acc.WellFoundedInductionI where

open import FOTC.Base
open import FOTC.Data.List
open import FOTC.Data.List.LT-Length
open import FOTC.Data.List.LT-Length.PropertiesI
open import FOTC.Data.List.PropertiesI

import FOTC.Data.Nat.Induction.Acc.WellFoundedInductionI
open FOTC.Data.Nat.Induction.Acc.WellFoundedInductionI.WF-<

open import FOTC.Data.Nat.Inequalities
open import FOTC.Data.Nat.Type
open import FOTC.Induction.WellFounded

-- Parametrized modules
open module InvImg =
  FOTC.Induction.WellFounded.InverseImage {List} {N} {_<_} lengthList-N

------------------------------------------------------------------------------
-- The relation LTL is well-founded (using the inverse image combinator).
wf-LTL : WellFounded LTL
wf-LTL Lxs = wellFounded wf-< Lxs

-- Well-founded induction on the relation LTL.
LTL-wfind : (A : D → Set) →
            (∀ {xs} → List xs → (∀ {ys} → List ys → LTL ys xs → A ys) → A xs) →
            ∀ {xs} → List xs → A xs
LTL-wfind A = WellFoundedInduction wf-LTL

------------------------------------------------------------------------------
-- The relation LTL is well-founded (a different proof).
-- Adapted from FOTC.Data.Nat.Induction.Acc.WellFoundedInduction.WF₁-LT.
module WF₁-LTL where

wf-LTL₁ : WellFounded LTL
wf-LTL₁ Lxs = acc (helper Lxs)
  where
  helper : ∀ {xs ys} → List xs → List ys → LTL ys xs → Acc List LTL ys
  helper lnil Lys ys<[] = ⊥-elim (xs<[]→⊥ Lys ys<[])
  helper (lcons x {xs} Lxs) lnil []<x∷xs =
    acc (λ Lys ys<[] → ⊥-elim (xs<[]→⊥ Lys ys<[]))
  helper (lcons x {xs} Lxs) (lcons y {ys} Lys) y∷ys<x∷xs =
    acc (λ {zs} Lzs zs<y∷ys →
           let ys<xs : LTL ys xs
               ys<xs = x∷xs<y∷ys→xs<ys Lys Lxs y∷ys<x∷xs

               zs<xs : LTL zs xs
               zs<xs = case (λ zs<ys → <-trans Lzs Lys Lxs zs<ys ys<xs)
                            (λ h → lg-xs≡lg-ys→ys<zx→xs<zs h ys<xs)
                            (xs<y∷ys→xs<ys∨lg-xs≡lg-ys Lzs Lys zs<y∷ys)

           in  helper Lxs Lzs zs<xs
        )
