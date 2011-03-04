------------------------------------------------------------------------------
-- The FOTC booleans type
------------------------------------------------------------------------------

module FOTC.Data.Bool.Type where

open import FOTC.Base

------------------------------------------------------------------------------
-- The FOTC booleans type.
data Bool : D → Set where
  tB : Bool true
  fB : Bool false
{-# ATP hint tB #-}
{-# ATP hint fB #-}

-- The rule of proof by case analysis on Bool.
indBool : (P : D → Set) → P true → P false → ∀ {b} → Bool b → P b
indBool P Pt Pf tB = Pt
indBool P Pt Pf fB = Pf
