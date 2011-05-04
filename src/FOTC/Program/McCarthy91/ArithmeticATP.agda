------------------------------------------------------------------------------
-- Arithmetic properties used by the McCarthy 91 function
------------------------------------------------------------------------------

module FOTC.Program.McCarthy91.ArithmeticATP where

open import FOTC.Base

open import FOTC.Data.Nat
open import FOTC.Data.Nat.Inequalities
open import FOTC.Data.Nat.Inequalities.PropertiesATP
open import FOTC.Data.Nat.PropertiesATP
open import FOTC.Data.Nat.UnaryNumbers
open import FOTC.Data.Nat.UnaryNumbers.IsN-ATP

------------------------------------------------------------------------------

postulate
  91≡[100+11∸10]∸10 : (one-hundred + eleven ∸ ten) ∸ ten ≡ ninety-one
{-# ATP prove 91≡[100+11∸10]∸10 #-}

postulate
  100≡89+11     : eighty-nine + eleven         ≡ one-hundred
  101≡90+11≡101 : ninety + eleven              ≡ hundred-one
  101≡100+11-10 : (one-hundred + eleven) ∸ ten ≡ hundred-one
  102≡91+11     : ninety-one + eleven          ≡ hundred-two
  103≡92+1      : ninety-two + eleven          ≡ hundred-three
  104≡93+11     : ninety-three + eleven        ≡ hundred-four
  105≡94+11     : ninety-four + eleven         ≡ hundred-five
  106≡95+11     : ninety-five + eleven         ≡ hundred-six
  107≡96+11     : ninety-six + eleven          ≡ hundred-seven
  108≡97+11     : ninety-seven + eleven        ≡ hundred-eight
  109≡99+11     : ninety-eight + eleven        ≡ hundred-nine
  110≡99+11     : ninety-nine + eleven         ≡ hundred-ten
  111≡100+11    : one-hundred + eleven         ≡ hundred-eleven

{-# ATP prove 100≡89+11 #-}
{-# ATP prove 101≡90+11≡101 #-}
{-# ATP prove 101≡100+11-10 #-}
{-# ATP prove 102≡91+11 #-}
{-# ATP prove 103≡92+1 #-}
{-# ATP prove 104≡93+11 #-}
{-# ATP prove 105≡94+11 #-}
{-# ATP prove 106≡95+11 #-}
{-# ATP prove 107≡96+11 #-}
{-# ATP prove 108≡97+11 #-}
{-# ATP prove 109≡99+11 #-}
{-# ATP prove 110≡99+11 #-}
{-# ATP prove 111≡100+11 #-}

postulate
  101>100  : GT ((one-hundred + eleven) ∸ ten) one-hundred
  111>100' : GT hundred-eleven                 one-hundred
  111>100  : GT (one-hundred + eleven)         one-hundred
{-# ATP prove 101>100 101≡100+11-10 #-}
{-# ATP prove 111>100' #-}
{-# ATP prove 111>100 111≡100+11 #-}

postulate
  99+11>100 : GT (ninety-nine + eleven)  one-hundred
  98+11>100 : GT (ninety-eight + eleven) one-hundred
  97+11>100 : GT (ninety-seven + eleven) one-hundred
  96+11>100 : GT (ninety-six + eleven)   one-hundred
  95+11>100 : GT (ninety-five + eleven)  one-hundred
  94+11>100 : GT (ninety-four + eleven)  one-hundred
  93+11>100 : GT (ninety-three + eleven) one-hundred
  92+11>100 : GT (ninety-two + eleven)   one-hundred
  91+11>100 : GT (ninety-one + eleven)   one-hundred
  90+11>100 : GT (ninety + eleven)       one-hundred
{-# ATP prove 99+11>100 110≡99+11 #-}
{-# ATP prove 98+11>100 109≡99+11 #-}
{-# ATP prove 97+11>100 108≡97+11 #-}
{-# ATP prove 96+11>100 107≡96+11 #-}
{-# ATP prove 95+11>100 106≡95+11 #-}
{-# ATP prove 94+11>100 105≡94+11 #-}
{-# ATP prove 93+11>100 104≡93+11 #-}
{-# ATP prove 92+11>100 103≡92+1 #-}
{-# ATP prove 91+11>100 102≡91+11 #-}
{-# ATP prove 90+11>100 101≡90+11≡101 #-}

postulate
  100<102' : LT one-hundred hundred-two
  100<102  : LT one-hundred (ninety-one + eleven)
{-# ATP prove 100<102' #-}
{-# ATP prove 100<102 100<102' 102≡91+11 #-}

x+11-N : ∀ {n} → N n → N (n + eleven)
x+11-N Nn = +-N Nn 11-N

x+11∸10≡Sx : ∀ {n} → N n → (n + eleven) ∸ ten ≡ succ n
x+11∸10≡Sx Nn = [x+Sy]∸y≡Sx Nn 10-N

postulate 91>100→⊥ : GT ninety-one one-hundred → ⊥
{-# ATP prove 91>100→⊥ #-}

postulate x+1≤x∸10+11 : ∀ {n} → N n → LE (n + one) ((n ∸ ten) + eleven)
{-# ATP prove x+1≤x∸10+11 x≤y+x∸y 10-N 11-N +-N ∸-N +-comm #-}

postulate x≤89→x+11>100→⊥ : ∀ {n} → N n → LE n eighty-nine →
                            GT (n + eleven) one-hundred → ⊥
{-# ATP prove x≤89→x+11>100→⊥ x>y→x≤y→⊥ x≤y→x+k≤y+k x+11-N 89-N 100-N
                              100≡89+11
#-}
