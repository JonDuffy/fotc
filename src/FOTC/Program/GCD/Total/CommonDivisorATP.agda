------------------------------------------------------------------------------
-- The gcd is a common divisor
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module FOTC.Program.GCD.Total.CommonDivisorATP where

open import Common.Function

open import FOTC.Base
open import FOTC.Base.Properties
open import FOTC.Data.Nat
open import FOTC.Data.Nat.Divisibility.By0
open import FOTC.Data.Nat.Divisibility.By0.PropertiesATP
open import FOTC.Data.Nat.Induction.NonAcc.LexicographicATP
open import FOTC.Data.Nat.Inequalities
open import FOTC.Data.Nat.Inequalities.EliminationProperties
open import FOTC.Data.Nat.Inequalities.PropertiesATP
open import FOTC.Data.Nat.PropertiesATP
open import FOTC.Program.GCD.Total.Definitions
open import FOTC.Program.GCD.Total.GCD
open import FOTC.Program.GCD.Total.TotalityATP

------------------------------------------------------------------------------
-- gcd 0 0 | 0
postulate
  gcd-00∣0 : gcd zero zero ∣ zero
{-# ATP prove gcd-00∣0 #-}

------------------------------------------------------------------------------
-- Some cases of the gcd-∣₁.

-- We don't prove that 'gcd-∣₁ : ... → (gcd m n) ∣ m'
-- because this proof should be defined mutually recursive with the proof
-- 'gcd-∣₂ : ... → (gcd m n) ∣ n'. Therefore, instead of prove
-- 'gcd-CD : ... → CD m n (gcd m n)' using these proof (i.e. the conjunction
-- of them), we proved it using well-founded induction.

-- gcd 0 (succ n) ∣ 0.
postulate gcd-0S-∣₁ : ∀ {n} → N n → gcd zero (succ₁ n) ∣ zero
{-# ATP prove gcd-0S-∣₁ #-}

-- gcd (succ₁ m) 0 ∣ succ₁ m.
postulate gcd-S0-∣₁ : ∀ {n} → N n → gcd (succ₁ n) zero ∣ succ₁ n
{-# ATP prove gcd-S0-∣₁ ∣-refl #-}

-- gcd (succ₁ m) (succ₁ n) ∣ succ₁ m, when succ₁ m ≯ succ₁ n.
postulate
  gcd-S≯S-∣₁ :
    ∀ {m n} → N m → N n →
    (gcd (succ₁ m) (succ₁ n ∸ succ₁ m) ∣ succ₁ m) →
    NGT (succ₁ m) (succ₁ n) →
    gcd (succ₁ m) (succ₁ n) ∣ succ₁ m
{-# ATP prove gcd-S≯S-∣₁ #-}

-- gcd (succ₁ m) (succ₁ n) ∣ succ₁ m when succ₁ m > succ₁ n.
{- Proof:
1. gcd (Sm ∸ Sn) Sn | (Sm ∸ Sn)        IH
2. gcd (Sm ∸ Sn) Sn | Sn               gcd-∣₂
3. gcd (Sm ∸ Sn) Sn | (Sm ∸ Sn) + Sn   m∣n→m∣o→m∣n+o 1,2
4. Sm > Sn                             Hip
5. gcd (Sm ∸ Sn) Sn | Sm               arith-gcd-m>n₂ 3,4
6. gcd Sm Sn = gcd (Sm ∸ Sn) Sn        gcd eq. 4
7. gcd Sm Sn | Sm                      subst 5,6
-}

-- For the proof using the ATP we added the helper hypothesis:
-- 1. gcd (succ₁ m ∸ succ₁ n) (succ₁ n) ∣ (succ₁ m ∸ succ₁ n) + succ₁ n.
-- 2. (succ₁ m ∸ succ₁ n) + succ₁ n ≡ succ₁ m.
postulate
  gcd-S>S-∣₁-ah :
    ∀ {m n} → N m → N n →
    (gcd (succ₁ m ∸ succ₁ n) (succ₁ n) ∣ (succ₁ m ∸ succ₁ n)) →
    (gcd (succ₁ m ∸ succ₁ n) (succ₁ n) ∣ succ₁ n) →
    GT (succ₁ m) (succ₁ n) →
    gcd (succ₁ m ∸ succ₁ n) (succ₁ n) ∣ (succ₁ m ∸ succ₁ n) + succ₁ n →
    ((succ₁ m ∸ succ₁ n) + succ₁ n ≡ succ₁ m) →
    gcd (succ₁ m) (succ₁ n) ∣ succ₁ m
-- E 1.2: CPU time limit exceeded (180 sec).
-- Metis 2.3 (release 20101019): SZS status Unknown (using timeout 180 sec).
{-# ATP prove gcd-S>S-∣₁-ah #-}

gcd-S>S-∣₁ :
  ∀ {m n} → N m → N n →
  (gcd (succ₁ m ∸ succ₁ n) (succ₁ n) ∣ (succ₁ m ∸ succ₁ n)) →
  (gcd (succ₁ m ∸ succ₁ n) (succ₁ n) ∣ succ₁ n) →
  GT (succ₁ m) (succ₁ n) →
  gcd (succ₁ m) (succ₁ n) ∣ succ₁ m
gcd-S>S-∣₁ {m} {n} Nm Nn ih gcd-∣₂ Sm>Sn =
  gcd-S>S-∣₁-ah Nm Nn ih gcd-∣₂ Sm>Sn
    (x∣y→x∣z→x∣y+z gcd-Sm-Sn,Sn-N Sm-Sn-N (sN Nn) ih gcd-∣₂)
    (x>y→x∸y+y≡x (sN Nm) (sN Nn) Sm>Sn)

  where
  Sm-Sn-N : N (succ₁ m ∸ succ₁ n)
  Sm-Sn-N = ∸-N (sN Nm) (sN Nn)

  gcd-Sm-Sn,Sn-N : N (gcd (succ₁ m ∸ succ₁ n) (succ₁ n))
  gcd-Sm-Sn,Sn-N = gcd-N Sm-Sn-N (sN Nn)

------------------------------------------------------------------------------
-- Some case of the gcd-∣₂.
-- We don't prove that gcd-∣₂ : ... → gcd m n ∣ n. The reason is
-- the same to don't prove gcd-∣₁ : ... → gcd m n ∣ m.

-- gcd 0 (succ₁ n) ∣₂ succ₁ n.
postulate gcd-0S-∣₂ : ∀ {n} → N n → gcd zero (succ₁ n) ∣ succ₁ n
{-# ATP prove gcd-0S-∣₂ ∣-refl #-}

-- gcd (succ₁ m) 0 ∣ 0.
postulate gcd-S0-∣₂ : ∀ {m} → N m → gcd (succ₁ m) zero ∣ zero
{-# ATP prove gcd-S0-∣₂ #-}

-- gcd (succ₁ m) (succ₁ n) ∣ succ₁ n when succ₁ m ≯ succ₁ n.
{- Proof:
1. gcd Sm (Sn ∸ Sm) | (Sn ∸ Sm)        IH
2  gcd Sm (Sn ∸ Sm) | Sm               gcd-∣₁
3. gcd Sm (Sn ∸ Sm) | (Sn ∸ Sm) + Sm   m∣n→m∣o→m∣n+o 1,2
4. Sm ≯ Sn                             Hip
5. gcd (Sm ∸ Sn) Sn | Sm               arith-gcd-m≤n₂ 3,4
6. gcd Sm Sn = gcd Sm (Sn ∸ Sm)        gcd eq. 4
7. gcd Sm Sn | Sn                      subst 5,6
-}

-- For the proof using the ATP we added the helper hypothesis:
-- 1. gcd (succ₁ m) (succ₁ n ∸ succ₁ m) ∣ (succ₁ n ∸ succ₁ m) + succ₁ m.
-- 2 (succ₁ n ∸ succ₁ m) + succ₁ m ≡ succ₁ n.
postulate
  gcd-S≯S-∣₂-ah :
    ∀ {m n} → N m → N n →
    (gcd (succ₁ m) (succ₁ n ∸ succ₁ m) ∣ (succ₁ n ∸ succ₁ m)) →
    (gcd (succ₁ m) (succ₁ n ∸ succ₁ m) ∣ succ₁ m) →
    NGT (succ₁ m) (succ₁ n) →
    (gcd (succ₁ m) (succ₁ n ∸ succ₁ m) ∣ (succ₁ n ∸ succ₁ m) + succ₁ m) →
    ((succ₁ n ∸ succ₁ m) + succ₁ m ≡ succ₁ n) →
    gcd (succ₁ m) (succ₁ n) ∣ succ₁ n
{-# ATP prove gcd-S≯S-∣₂-ah #-}

gcd-S≯S-∣₂ :
  ∀ {m n} → N m → N n →
  (gcd (succ₁ m) (succ₁ n ∸ succ₁ m) ∣ (succ₁ n ∸ succ₁ m)) →
  (gcd (succ₁ m) (succ₁ n ∸ succ₁ m) ∣ succ₁ m) →
  NGT (succ₁ m) (succ₁ n) →
  gcd (succ₁ m) (succ₁ n) ∣ succ₁ n
gcd-S≯S-∣₂ {m} {n} Nm Nn ih gcd-∣₁ Sm≯Sn =
  gcd-S≯S-∣₂-ah Nm Nn ih gcd-∣₁ Sm≯Sn
    (x∣y→x∣z→x∣y+z gcd-Sm,Sn-Sm-N Sn-Sm-N (sN Nm) ih gcd-∣₁)
    (x≤y→y∸x+x≡y (sN Nm) (sN Nn) (x≯y→x≤y (sN Nm) (sN Nn) Sm≯Sn))

  where
  Sn-Sm-N : N (succ₁ n ∸ succ₁ m)
  Sn-Sm-N = ∸-N (sN Nn) (sN Nm)

  gcd-Sm,Sn-Sm-N : N (gcd (succ₁ m) (succ₁ n ∸ succ₁ m))
  gcd-Sm,Sn-Sm-N = gcd-N (sN Nm) (Sn-Sm-N)

-- gcd (succ₁ m) (succ₁ n) ∣ succ₁ n when succ₁ m > succ₁ n.
postulate
  gcd-S>S-∣₂ :
    ∀ {m n} → N m → N n →
    (gcd (succ₁ m ∸ succ₁ n) (succ₁ n) ∣ succ₁ n) →
    GT (succ₁ m) (succ₁ n) →
    gcd (succ₁ m) (succ₁ n) ∣ succ₁ n
-- Metis 2.3 (release 20101019): SZS status Unknown (using timeout 180 sec).
{-# ATP prove gcd-S>S-∣₂ #-}

------------------------------------------------------------------------------
-- The gcd is CD.
-- We will prove that gcd-CD : ... → CD m n (gcd m n).

-- The gcd 0 0 is CD.
gcd-00-CD : CD zero zero (gcd zero zero)
gcd-00-CD = gcd-00∣0 , gcd-00∣0

-- The gcd 0 (succ₁ n) is CD.
gcd-0S-CD : ∀ {n} → N n → CD zero (succ₁ n) (gcd zero (succ₁ n))
gcd-0S-CD Nn = (gcd-0S-∣₁ Nn , gcd-0S-∣₂ Nn)

-- The gcd (succ₁ m) 0 is CD.
gcd-S0-CD : ∀ {m} → N m → CD (succ₁ m) zero (gcd (succ₁ m) zero)
gcd-S0-CD Nm = (gcd-S0-∣₁ Nm , gcd-S0-∣₂ Nm)

-- The gcd (succ₁ m) (succ₁ n) when succ₁ m > succ₁ n is CD.
gcd-S>S-CD :
  ∀ {m n} → N m → N n →
  (CD (succ₁ m ∸ succ₁ n) (succ₁ n) (gcd (succ₁ m ∸ succ₁ n) (succ₁ n))) →
  GT (succ₁ m) (succ₁ n) →
  CD (succ₁ m) (succ₁ n) (gcd (succ₁ m) (succ₁ n))
gcd-S>S-CD {m} {n} Nm Nn acc Sm>Sn =
   (gcd-S>S-∣₁ Nm Nn acc-∣₁ acc-∣₂ Sm>Sn , gcd-S>S-∣₂ Nm Nn acc-∣₂ Sm>Sn)
  where
  acc-∣₁ : gcd (succ₁ m ∸ succ₁ n) (succ₁ n) ∣ (succ₁ m ∸ succ₁ n)
  acc-∣₁ = ∧-proj₁ acc

  acc-∣₂ : gcd (succ₁ m ∸ succ₁ n) (succ₁ n) ∣ succ₁ n
  acc-∣₂ = ∧-proj₂ acc

-- The gcd (succ₁ m) (succ₁ n) when succ₁ m ≯ succ₁ n is CD.
gcd-S≯S-CD :
  ∀ {m n} → N m → N n →
  (CD (succ₁ m) (succ₁ n ∸ succ₁ m) (gcd (succ₁ m) (succ₁ n ∸ succ₁ m))) →
  NGT (succ₁ m) (succ₁ n) →
  CD (succ₁ m) (succ₁ n) (gcd (succ₁ m) (succ₁ n))
gcd-S≯S-CD {m} {n} Nm Nn acc Sm≯Sn =
  (gcd-S≯S-∣₁ Nm Nn acc-∣₁ Sm≯Sn , gcd-S≯S-∣₂ Nm Nn acc-∣₂ acc-∣₁ Sm≯Sn)
  where
  acc-∣₁ : gcd (succ₁ m) (succ₁ n ∸ succ₁ m) ∣ succ₁ m
  acc-∣₁ = ∧-proj₁ acc

  acc-∣₂ : gcd (succ₁ m) (succ₁ n ∸ succ₁ m) ∣ (succ₁ n ∸ succ₁ m)
  acc-∣₂ = ∧-proj₂ acc

-- The gcd m n when m > n is CD.
gcd-x>y-CD :
  ∀ {m n} → N m → N n →
  (∀ {o p} → N o → N p → LT₂ o p m n → CD o p (gcd o p)) →
  GT m n →
  CD m n (gcd m n)
gcd-x>y-CD zN          Nn          _    0>n   = ⊥-elim $ 0>x→⊥ Nn 0>n
gcd-x>y-CD (sN Nm)     zN          _    _     = gcd-S0-CD Nm
gcd-x>y-CD (sN {m} Nm) (sN {n} Nn) accH Sm>Sn = gcd-S>S-CD Nm Nn ih Sm>Sn
  where
  -- Inductive hypothesis.
  ih : CD (succ₁ m ∸ succ₁ n) (succ₁ n) (gcd (succ₁ m ∸ succ₁ n) (succ₁ n))
  ih  = accH {succ₁ m ∸ succ₁ n}
             {succ₁ n}
             (∸-N (sN Nm) (sN Nn))
             (sN Nn)
             ([Sx∸Sy,Sy]<[Sx,Sy] Nm Nn)

-- The gcd m n when m ≯ n is CD.
gcd-x≯y-CD :
  ∀ {m n} → N m → N n →
  (∀ {o p} → N o → N p → LT₂ o p m n → CD o p (gcd o p)) →
  NGT m n →
  CD m n (gcd m n)
gcd-x≯y-CD zN          zN          _    _     = gcd-00-CD
gcd-x≯y-CD zN          (sN Nn)     _    _     = gcd-0S-CD Nn
gcd-x≯y-CD (sN _)      zN          _    Sm≯0  = ⊥-elim $ S≯0→⊥ Sm≯0
gcd-x≯y-CD (sN {m} Nm) (sN {n} Nn) accH Sm≯Sn =
  gcd-S≯S-CD Nm Nn ih Sm≯Sn
  where
  -- Inductive hypothesis.
  ih : CD (succ₁ m) (succ₁ n ∸ succ₁ m)  (gcd (succ₁ m) (succ₁ n ∸ succ₁ m))
  ih = accH {succ₁ m}
            {succ₁ n ∸ succ₁ m}
            (sN Nm)
            (∸-N (sN Nn) (sN Nm))
            ([Sx,Sy∸Sx]<[Sx,Sy] Nm Nn)

-- The gcd is CD.
gcd-CD : ∀ {m n} → N m → N n → CD m n (gcd m n)
gcd-CD = wfInd-LT₂ P istep
  where
  P : D → D → Set
  P i j = CD i j (gcd i j)

  istep : ∀ {i j} → N i → N j → (∀ {k l} → N k → N l → LT₂ k l i j → P k l) →
          P i j
  istep Ni Nj accH =
    [ gcd-x>y-CD Ni Nj accH
    , gcd-x≯y-CD Ni Nj accH
    ] (x>y∨x≯y Ni Nj)
