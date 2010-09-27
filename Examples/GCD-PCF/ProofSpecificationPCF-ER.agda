------------------------------------------------------------------------------
-- The gcd program satisfies the specification (using equational reasoning)
------------------------------------------------------------------------------

-- This module proves the correctness of the gcd program using
-- the Euclid's algorithm.

module Examples.GCD-PCF.ProofSpecificationPCF-ER where

open import LTC.Minimal

open import Examples.GCD.Types using ( ¬x≡0∧y≡0 )
open import Examples.GCD-PCF.GCD-PCF using ( gcd )
open import Examples.GCD-PCF.IsCommonDivisorPCF-ER using ( CD ; gcd-CD )
open import Examples.GCD-PCF.IsDivisiblePCF-ER using ( gcd-Divisible )
open import Examples.GCD-PCF.IsGreatestAnyCommonDivisorPCF-ER
  using ( GACD ; gcd-GACD )
open import Examples.GCD-PCF.IsN-PCF-ER using ( gcd-N )

open import LTC-PCF.DataPCF.NatPCF
  using ( N  -- The LTC natural numbers type.
        )

-----------------------------------------------------------------------
-- Greatest commun divisor.
record GCD (a b gcd : D) : Set where
  constructor is
  field
    -- The gcd is a common divisor.
    commonDivisor : CD a b gcd

    -- Greatest that any common divisor.
    greatest : GACD a b gcd

-- The 'gcd' is the GCD.
gcd-GCD : {m n : D} → N m → N n → ¬x≡0∧y≡0 m n → GCD m n (gcd m n)
gcd-GCD Nm Nn m≠0≠n = is (gcd-CD Nm Nn m≠0≠n)
                         (gcd-GACD (gcd-N Nm Nn m≠0≠n)
                                   (gcd-CD Nm Nn m≠0≠n)
                                   (gcd-Divisible Nm Nn m≠0≠n))
