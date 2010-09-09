------------------------------------------------------------------------------
-- PCF terms properties (using equational reasoning)
------------------------------------------------------------------------------

module LTC.Minimal.PropertiesER where

open import LTC.Minimal
open import LTC.MinimalER using ( subst )

open import LTC.Data.Nat.Type using
  ( N ; sN ; zN -- The LTC natural numbers type
  )

------------------------------------------------------------------------------
-- Closure properties

pred-N : {n : D} → N n → N (pred n)
pred-N zN          = subst (λ t → N t) (sym cP₁) zN
pred-N (sN {n} Nn) = subst (λ t → N t) (sym (cP₂ n)) Nn
