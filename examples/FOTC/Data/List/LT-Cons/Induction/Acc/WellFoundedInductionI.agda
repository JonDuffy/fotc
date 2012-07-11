------------------------------------------------------------------------------
-- Well-founded induction on the relation LTC
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module FOTC.Data.List.LT-Cons.Induction.Acc.WellFoundedInductionI where

open import FOTC.Base
open import FOTC.Data.List
open import FOTC.Data.List.LT-Cons
open import FOTC.Data.List.LT-Cons.PropertiesI
open import FOTC.Data.List.LT-Length
open import FOTC.Data.List.LT-Length.Induction.Acc.WellFoundedInductionI
open import FOTC.Induction.WellFounded

-- Parametrized modules
open module S = FOTC.Induction.WellFounded.Subrelation {List} {LTC} LTC→LTL

------------------------------------------------------------------------------
-- The relation LTL is well-founded (using the subrelation combinator).
wf-LTC : WellFounded LTC
wf-LTC Lxs = well-founded wf-LTL Lxs

-- Well-founded induction on the relation LTC.
LTC-wfind : (A : D → Set) →
            (∀ {xs} → List xs → (∀ {ys} → List ys → LTC ys xs → A ys) → A xs) →
            ∀ {xs} → List xs → A xs
LTC-wfind A = WellFoundedInduction wf-LTC