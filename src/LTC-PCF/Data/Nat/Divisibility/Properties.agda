------------------------------------------------------------------------------
-- Properties of the divisibility relation
------------------------------------------------------------------------------

module LTC-PCF.Data.Nat.Divisibility.Properties where

open import LTC-PCF.Base
open import FOTC.Base.Properties using ( ¬S≡0 )

open import Common.Function using ( _$_ )

open import LTC-PCF.Data.Nat.Divisibility using ( _∣_ )

------------------------------------------------------------------------------
-- 0 doesn't divide any number.
0∤x : ∀ {d} → ¬ (zero ∣ d)
0∤x (0≠0 , _) = ⊥-elim $ 0≠0 refl
