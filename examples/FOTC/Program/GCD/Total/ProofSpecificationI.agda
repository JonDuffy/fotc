------------------------------------------------------------------------------
-- The gcd program satisfies the specification
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

-- This module proves the correctness of the gcd program using
-- the Euclid's algorithm.

module FOTC.Program.GCD.Total.ProofSpecificationI where

open import FOTC.Base
open import FOTC.Data.Nat.Type
open import FOTC.Program.GCD.Total.CommonDivisorI using ( gcd-CD )
open import FOTC.Program.GCD.Total.Definitions using ( GCD )
open import FOTC.Program.GCD.Total.DivisibleI using ( gcd-Divisible )
open import FOTC.Program.GCD.Total.GCD using ( gcd )

------------------------------------------------------------------------------
-- The gcd is the GCD.
gcd-GCD : ∀ {m n} → N m → N n → GCD m n (gcd m n)
gcd-GCD Nm Nn = gcd-CD Nm Nn , gcd-Divisible Nm Nn
