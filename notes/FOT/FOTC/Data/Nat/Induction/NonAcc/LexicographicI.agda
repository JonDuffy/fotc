------------------------------------------------------------------------------
-- Well-founded induction on the lexicographic order on natural numbers
------------------------------------------------------------------------------

{-# OPTIONS --allow-unsolved-metas #-}
{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

-- From the thesis: The induction principle $\Conid{Lexi-wfind}$ is
-- proved by well-founded induction on the usual order $\Conid{LT}$ on
-- (partial) natural numbers which, in turn, can be proved by pattern
-- matching on the proof that the numbers are total.

module FOT.FOTC.Data.Nat.Induction.NonAcc.LexicographicI where

open import Common.Function

open import FOTC.Base
open import FOTC.Data.Nat.Inequalities
open import FOTC.Data.Nat.Inequalities.EliminationProperties
open import FOTC.Data.Nat.Inequalities.PropertiesI

open import FOTC.Data.Nat.Induction.NonAcc.WellFoundedInductionI
open module WFI = FOTC.Data.Nat.Induction.NonAcc.WellFoundedInductionI.WFInd

open import FOTC.Data.Nat.Type

------------------------------------------------------------------------------

Lexi-wfind :
  (A : D → D → Set) →
  (∀ {m₁ n₁} → N m₁ → N n₁ →
     (∀ {m₂ n₂} → N m₂ → N n₂ → Lexi m₂ n₂ m₁ n₁ → A m₂ n₂) → A m₁ n₁) →
  ∀ {m n} → N m → N n → A m n
Lexi-wfind A accH {m} Nm Nn = LT-wfind {!!} {!!} {!!}