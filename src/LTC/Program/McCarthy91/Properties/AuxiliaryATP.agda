------------------------------------------------------------------------------
-- Auxiliary properties of the McCarthy 91 function
------------------------------------------------------------------------------

module LTC.Program.McCarthy91.Properties.AuxiliaryATP where

open import LTC.Base

open import LTC.Data.Nat
open import LTC.Data.Nat.Inequalities
open import LTC.Data.Nat.Inequalities.PropertiesATP
open import LTC.Data.Nat.PropertiesATP
open import LTC.Data.Nat.UnaryNumbers
open import LTC.Data.Nat.UnaryNumbers.IsN-ATP
open import LTC.Data.Nat.UnaryNumbers.Inequalities.PropertiesATP

open import LTC.Program.McCarthy91.ArithmeticATP
open import LTC.Program.McCarthy91.McCarthy91

------------------------------------------------------------------------------

--- Auxiliary properties

---- Case n > 100
postulate
  Nmc91>100      : ∀ {n} → N n → GT n one-hundred → N (mc91 n)
  x<mc91x+11>100 : ∀ {n} → N n → GT n one-hundred →
                           LT n (mc91 n + eleven)
{-# ATP prove Nmc91>100 N10 ∸-N #-}
{-# ATP prove x<mc91x+11>100 +-N ∸-N N10 N11 x<y→y≤z→x<z x<x+1 x+1≤x∸10+11
              +-comm #-}

-- Most of them not needed
-- Case n ≡ 100 can be proved automatically
postulate
  Nmc91≡100     : N (mc91 one-hundred)
  mc91-res-100  : mc91 one-hundred ≡ ninety-one
  mc91-res-100' : ∀ {n} → n ≡ one-hundred → mc91 n ≡ ninety-one
  mc91<mc91+11  : LT  one-hundred (mc91 one-hundred + eleven)
{-# ATP prove Nmc91≡100 111>100 101>100 101≡100+11-10 91≡[100+11∸10]∸10
              Nmc91>100 N111 N101
#-}
{-# ATP prove mc91-res-100 111>100 101>100 101≡100+11-10 91≡[100+11∸10]∸10 #-}
{-# ATP prove mc91-res-100' mc91-res-100 #-}
{-# ATP prove Nmc91≡100 111>100 101>100 101≡100+11-10 91≡[100+11∸10]∸10 N91 #-}
{-# ATP prove mc91<mc91+11 mc91-res-100 102≡91+11 100<102 #-}


---- Case n ≤ 100

postulate
  Nmc91≤100'        : ∀ n → LE n one-hundred → N (mc91 (mc91 (n + eleven))) →
                      N (mc91 n)
  x<mc91x+11≤100'   : ∀ n → LE n one-hundred →
                      LT n (mc91 (mc91 (n + eleven)) + eleven) →
                      LT n (mc91 n + eleven)
  mc91x+11<mc91x+11 : ∀ n → LE n one-hundred →
                      LT (mc91 (n + eleven)) (mc91 (mc91 (n + eleven)) + eleven) →
                      LT (mc91 (n + eleven)) (mc91 n + eleven)
  mc91x-res≤100     : ∀ m n → LE m one-hundred →
                      mc91 (m + eleven) ≡ n → mc91 n ≡ ninety-one →
                      mc91 m ≡ ninety-one
{-# ATP prove Nmc91≤100' #-}
{-# ATP prove x<mc91x+11≤100' #-}
{-# ATP prove mc91x+11<mc91x+11 #-}
{-# ATP prove mc91x-res≤100 #-}

postulate
  mc91-res-110 : mc91 (ninety-nine + eleven)  ≡ one-hundred
  mc91-res-109 : mc91 (ninety-eight + eleven) ≡ ninety-nine
  mc91-res-108 : mc91 (ninety-seven + eleven) ≡ ninety-eight
  mc91-res-107 : mc91 (ninety-six + eleven)   ≡ ninety-seven
  mc91-res-106 : mc91 (ninety-five + eleven)  ≡ ninety-six
  mc91-res-105 : mc91 (ninety-four + eleven)  ≡ ninety-five
  mc91-res-104 : mc91 (ninety-three + eleven) ≡ ninety-four
  mc91-res-103 : mc91 (ninety-two + eleven)   ≡ ninety-three
  mc91-res-102 : mc91 (ninety-one + eleven)   ≡ ninety-two
  mc91-res-101 : mc91 (ninety + eleven)       ≡ ninety-one
{-# ATP prove mc91-res-110 99+11>100 x+11∸10≡Sx #-}
{-# ATP prove mc91-res-109 98+11>100 x+11∸10≡Sx #-}
{-# ATP prove mc91-res-108 97+11>100 x+11∸10≡Sx #-}
{-# ATP prove mc91-res-107 96+11>100 x+11∸10≡Sx #-}
{-# ATP prove mc91-res-106 95+11>100 x+11∸10≡Sx #-}
{-# ATP prove mc91-res-105 94+11>100 x+11∸10≡Sx #-}
{-# ATP prove mc91-res-104 93+11>100 x+11∸10≡Sx #-}
{-# ATP prove mc91-res-103 92+11>100 x+11∸10≡Sx #-}
{-# ATP prove mc91-res-102 91+11>100 x+11∸10≡Sx #-}
{-# ATP prove mc91-res-101 90+11>100 x+11∸10≡Sx #-}

postulate
  mc91-res-99 : mc91 ninety-nine  ≡ ninety-one
  mc91-res-98 : mc91 ninety-eight ≡ ninety-one
  mc91-res-97 : mc91 ninety-seven ≡ ninety-one
  mc91-res-96 : mc91 ninety-six   ≡ ninety-one
  mc91-res-95 : mc91 ninety-five  ≡ ninety-one
  mc91-res-94 : mc91 ninety-four  ≡ ninety-one
  mc91-res-93 : mc91 ninety-three ≡ ninety-one
  mc91-res-92 : mc91 ninety-two   ≡ ninety-one
  mc91-res-91 : mc91 ninety-one   ≡ ninety-one
  mc91-res-90 : mc91 ninety       ≡ ninety-one
{-# ATP prove mc91-res-99 mc91x-res≤100 mc91-res-110 mc91-res-100 #-}
{-# ATP prove mc91-res-98 mc91x-res≤100 mc91-res-109 mc91-res-99 #-}
{-# ATP prove mc91-res-97 mc91x-res≤100 mc91-res-108 mc91-res-98 #-}
{-# ATP prove mc91-res-96 mc91x-res≤100 mc91-res-107 mc91-res-97 #-}
{-# ATP prove mc91-res-95 mc91x-res≤100 mc91-res-106 mc91-res-96 #-}
{-# ATP prove mc91-res-94 mc91x-res≤100 mc91-res-105 mc91-res-95 #-}
{-# ATP prove mc91-res-93 mc91x-res≤100 mc91-res-104 mc91-res-94 #-}
{-# ATP prove mc91-res-92 mc91x-res≤100 mc91-res-103 mc91-res-93 #-}
{-# ATP prove mc91-res-91 mc91x-res≤100 mc91-res-102 mc91-res-92 #-}
{-# ATP prove mc91-res-90 mc91x-res≤100 mc91-res-101 mc91-res-91 #-}

mc91-res-99' : ∀ {n} → n ≡ ninety-nine → mc91 n ≡ ninety-one
mc91-res-99' refl = mc91-res-99

mc91-res-98' : ∀ {n} → n ≡ ninety-eight → mc91 n ≡ ninety-one
mc91-res-98' refl = mc91-res-98

mc91-res-97' : ∀ {n} → n ≡ ninety-seven → mc91 n ≡ ninety-one
mc91-res-97' refl = mc91-res-97

mc91-res-96' : ∀ {n} → n ≡ ninety-six → mc91 n ≡ ninety-one
mc91-res-96' refl = mc91-res-96

mc91-res-95' : ∀ {n} → n ≡ ninety-five → mc91 n ≡ ninety-one
mc91-res-95' refl = mc91-res-95

mc91-res-94' : ∀ {n} → n ≡ ninety-four → mc91 n ≡ ninety-one
mc91-res-94' refl = mc91-res-94

mc91-res-93' : ∀ {n} → n ≡ ninety-three → mc91 n ≡ ninety-one
mc91-res-93' refl = mc91-res-93

mc91-res-92' : ∀ {n} → n ≡ ninety-two → mc91 n ≡ ninety-one
mc91-res-92' refl = mc91-res-92

mc91-res-91' : ∀ {n} → n ≡ ninety-one → mc91 n ≡ ninety-one
mc91-res-91' refl = mc91-res-91

mc91-res-90' : ∀ {n} → n ≡ ninety → mc91 n ≡ ninety-one
mc91-res-90' refl = mc91-res-90
