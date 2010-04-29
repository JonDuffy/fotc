------------------------------------------------------------------------------
-- Arithmetic functions on partial natural numbers
------------------------------------------------------------------------------

module LTC.Function.Arithmetic where

open import LTC.Minimal
open import LTC.Data.N

------------------------------------------------------------------------------
infixl 7 _*_
infixl 6 _+_ _-_

postulate
  _+_    : D → D → D
  +-0x : (d : D) →   zero   + d ≡ d
  +-Sx : (d e : D) → succ d + e ≡ succ (d + e)
{-# ATP axiom +-0x #-}
{-# ATP axiom +-Sx #-}

postulate
  _-_      : D → D → D
  minus-x0 : (d : D) →   d - zero   ≡ d
  minus-xS : (d e : D) → d - succ e ≡ pred (d - e)
{-# ATP axiom minus-x0 #-}
{-# ATP axiom minus-xS #-}

postulate
  _*_ : D → D → D
  *-0x : (d : D)   → zero   * d ≡ zero
  *-Sx : (d e : D) → succ d * e ≡ e + d * e
{-# ATP axiom *-0x #-}
{-# ATP axiom *-Sx #-}

