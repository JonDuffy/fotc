------------------------------------------------------------------------------
-- Properties of the recursive operator rec
------------------------------------------------------------------------------

module LTC.Function.Rec.Properties where

open import LTC.Minimal
open import LTC.Function.Rec

------------------------------------------------------------------------------

postulate
  rec-0 : (a : D){f : D} → rec zero a f ≡ a
{-# ATP prove rec-0 #-}

postulate
  rec-S : (n a f : D) → rec (succ n) a f ≡ f ∙ n ∙ (rec n a f)
{-# ATP prove rec-S #-}
