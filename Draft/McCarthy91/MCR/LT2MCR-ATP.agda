------------------------------------------------------------------------------
-- Property LT2MCR which proves that the recursive calls of the
-- McCarthy 91 functions are on smaller arguments.
------------------------------------------------------------------------------

module Draft.McCarthy91.MCR.LT2MCR-ATP where

open import LTC.Base

open import Draft.McCarthy91.MCR

open import LTC.Data.Nat
open import LTC.Data.Nat.Inequalities
open import LTC.Data.Nat.Inequalities.PropertiesATP
open import LTC.Data.Nat.Unary.Numbers
open import LTC.Data.Nat.Unary.IsN-ATP

------------------------------------------------------------------------------

LT2MCR-aux : ∀ {n m k} → N n → N m → N k →
             LT m n → LT (succ n) k → LT (succ m) k →
             LT (k ∸ n) (k ∸ m) → LT (k ∸ succ n) (k ∸ succ m)
LT2MCR-aux zN Nm Nk p qn qm h = ⊥-elim (x<0→⊥ Nm p)
LT2MCR-aux (sN Nn) Nm zN p qn qm h = ⊥-elim (x<0→⊥ (sN Nm) qm)
LT2MCR-aux (sN {n} Nn) zN (sN {k} Nk) p qn qm h = prfS0S
  where postulate k≥Sn : GE k (succ n)
                  k-Sn<k : LT (k ∸ (succ n)) k
                  prfS0S : LT (succ k ∸ succ (succ n)) (succ k ∸ succ zero)
        {-# ATP prove k≥Sn x<y→x≤y #-}
        {-# ATP prove k-Sn<k k≥Sn x≥y→y>0→x∸y<x #-}
        {-# ATP prove prfS0S k-Sn<k #-}
LT2MCR-aux (sN {n} Nn) (sN {m} Nm) (sN {k} Nk) p qn qm h =
          k-Sn<k-Sm→Sk-SSn<Sk-SSm (LT2MCR-aux Nn Nm Nk m<n Sn<k Sm<k k-n<k-m)
  where postulate k-Sn<k-Sm→Sk-SSn<Sk-SSm : LT (k ∸ succ n) (k ∸ succ m) →
                            LT (succ k ∸ succ (succ n)) (succ k ∸ succ (succ m))
                  m<n : LT m n
                  Sn<k : LT (succ n) k
                  Sm<k : LT (succ m) k
                  k-n<k-m : LT (k ∸ n) (k ∸ m)
        {-# ATP prove  k-Sn<k-Sm→Sk-SSn<Sk-SSm #-}
        {-# ATP prove m<n #-}
        {-# ATP prove Sn<k #-}
        {-# ATP prove Sm<k #-}
        {-# ATP prove k-n<k-m #-}

LT2MCR : ∀ {n m} → N n → N m → LE m one-hundred → LT m n → MCR n m
LT2MCR zN Nm p h = ⊥-elim (x<0→⊥ Nm h)
LT2MCR (sN {n} Nn) zN p h = prfS0
  where postulate prfS0 : MCR (succ n) zero
        {-# ATP prove prfS0 x∸y<Sx #-}
LT2MCR (sN {n} Nn) (sN {m} Nm) p h with x<y∨x≥y Nn N100
... | inj₁ n<100 = LT2MCR-aux Nn Nm N101 m<n Sn≤101 Sm≤101
                             (LT2MCR Nn Nm m≤100 m<n)
  where postulate m≤100 : LE m one-hundred
                  m<n : LT m n
                  Sn≤101 : LT (succ n) hundred-one
                  Sm≤101 : LT (succ m) hundred-one
        {-# ATP prove m≤100 x<y→x≤y #-}
        {-# ATP prove m<n #-}
        {-# ATP prove Sn≤101 #-}
        {-# ATP prove Sm≤101 #-}
... | inj₂ n≥199 = prf-n≥100
  where postulate 101-Sn=0 : hundred-one ∸ succ n ≡ zero
                  0<101-Sm : LT zero (hundred-one ∸ succ m)
                  prf-n≥100 : MCR (succ n) (succ m)
        {-# ATP prove 101-Sn=0 x≤y→x-y≡0 #-}
        {-# ATP prove 0<101-Sm x<y→0<x∸y #-}
        {-# ATP prove prf-n≥100 101-Sn=0 0<101-Sm #-}
