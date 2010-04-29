------------------------------------------------------------------------------
-- The gcd is a common divisor
------------------------------------------------------------------------------

module Examples.GCD.Properties.IsCommonDivisor where

open import LTC.Minimal

open import Examples.GCD
open import Examples.GCD.Properties.IsN

open import LTC.Data.N
open import LTC.Data.N.Postulates using ( wf₂-indN )
open import LTC.Function.Arithmetic
open import LTC.Function.Arithmetic.Properties
open import LTC.Relation.Divisibility
open import LTC.Relation.Divisibility.Properties
open import LTC.Relation.Divisibility.Postulates using ( x∣y→x∣z→x∣y+z )
open import LTC.Relation.Equalities.Properties
open import LTC.Relation.Inequalities
open import LTC.Relation.Inequalities.Postulates
  using ( x>y→x-y+y≡x
        ; x≤y→y-x+x≡y
        ; Sx>Sy→[Sx-Sy,Sy]<₂[Sx,Sy]
        ; Sx≤Sy→[Sx,Sy-Sx]<₂[Sx,Sy]
        )
open import LTC.Relation.Inequalities.Properties

open import MyStdLib.Data.Sum
open import MyStdLib.Function

---------------------------------------------------------------------------
-- Common divisor.
---------------------------------------------------------------------------

CD : D → D → D → Set
CD m n d = (d ∣ m) ∧ (d ∣ n)
{-# ATP definition CD #-}

-- We will prove that 'gcd-CD : ... → CD m n (gcd m n).

---------------------------------------------------------------------------
-- Some cases of the gcd-∣₁
---------------------------------------------------------------------------

-- We don't prove that 'gcd-∣₁ : ... → (gcd m n) ∣ m'
-- because this proof should be defined mutually recursive with the proof
-- 'gcd-∣₂ : ... → (gcd m n) ∣ n'. Therefore, instead of prove
-- 'gcd-CD : ... → CD m n (gcd m n)' using these proof (i.e. the conjunction
-- of them), we proved it using well-found induction.

---------------------------------------------------------------------------
-- 'gcd 0 (succ n) ∣ 0'.

postulate gcd-0S-∣₁ : {n : D} → N n → gcd zero (succ n) ∣ zero
{-# ATP prove gcd-0S-∣₁ zN #-}

-----------------------------------------------------------------------
-- 'gcd (succ m) 0 ∣ succ m'.

postulate gcd-S0-∣₁ : {n : D} → N n → gcd (succ n) zero ∣ succ n
{-# ATP prove gcd-S0-∣₁ ∣-refl-S #-}

---------------------------------------------------------------------------
-- 'gcd (succ m) (succ n) ∣ succ m', when 'succ m ≤ succ n'.

-- Proved very fast by Equinox.
postulate
  gcd-S≤S-∣₁ :
    {m n : D} → N m → N n →
    (gcd (succ m) (succ n - succ m) ∣ succ m) →
    LE (succ m) (succ n) →
    gcd (succ m) (succ n) ∣ succ m
{-# ATP prove gcd-S≤S-∣₁ #-}

---------------------------------------------------------------------------
-- 'gcd (succ m) (succ n) ∣ succ m' when 'succ m > succ n'.

{- Proof:
1. gcd (Sm - Sn) Sn | (Sm - Sn)        IH
2. gcd (Sm - Sn) Sn | Sn               gcd-∣₂
3. gcd (Sm - Sn) Sn | (Sm - Sn) + Sn   m∣n→m∣o→m∣n+o 1,2
4. Sm > Sn                             Hip
5. gcd (Sm - Sn) Sn | Sm               arith-gcd-m>n₂ 3,4
6. gcd Sm Sn = gcd (Sm - Sn) Sn        gcd eq. 4
7. gcd Sm Sn | Sm                      subst 5,6
-}

-- For the proof using the ATP we added the auxiliar hypothesis:
-- 1. gcd (succ m - succ n) (succ n) ∣ (succ m - succ n) + succ n.
-- 2. (succ m - succ n) + succ n ≡ succ m.

postulate
  gcd-S>S-∣₁-ah :
    {m n : D} → N m → N n →
    (gcd (succ m - succ n) (succ n) ∣ (succ m - succ n)) →
    (gcd (succ m - succ n) (succ n) ∣ succ n) →
    GT (succ m) (succ n) →
    gcd (succ m - succ n) (succ n) ∣ (succ m - succ n) + succ n →
    ((succ m - succ n) + succ n ≡ succ m) →
    gcd (succ m) (succ n) ∣ succ m
{-# ATP prove gcd-S>S-∣₁-ah #-}

gcd-S>S-∣₁ :
  {m n : D} → N m → N n →
  (gcd (succ m - succ n) (succ n) ∣ (succ m - succ n)) →
  (gcd (succ m - succ n) (succ n) ∣ succ n) →
  GT (succ m) (succ n) →
  gcd (succ m) (succ n) ∣ succ m
gcd-S>S-∣₁ {m} {n} Nm Nn ih gcd-∣₂ Sm>Sn =
  gcd-S>S-∣₁-ah Nm Nn ih gcd-∣₂ Sm>Sn
    (x∣y→x∣z→x∣y+z gcd-Sm-Sn,Sn-N Sm-Sn-N (sN Nn) ih gcd-∣₂)
    (x>y→x-y+y≡x (sN Nm) (sN Nn) Sm>Sn)

  where
  Sm-Sn-N : N (succ m - succ n)
  Sm-Sn-N = minus-N (sN Nm) (sN Nn)

  gcd-Sm-Sn,Sn-N : N (gcd (succ m - succ n) (succ n))
  gcd-Sm-Sn,Sn-N = gcd-N Sm-Sn-N (sN Nn) (λ p → ⊥-elim (¬S≡0 (∧-proj₂ p)))

---------------------------------------------------------------------------
-- Some case of the gcd-∣₂
---------------------------------------------------------------------------

-- We don't prove that 'gcd-∣₂ : ... → gcd m n ∣ n'. The reason is
-- the same to don't prove 'gcd-∣₁ : ... → gcd m n ∣ m'.

---------------------------------------------------------------------------
-- 'gcd 0 (succ n) ∣₂ succ n'.

postulate gcd-0S-∣₂ : {n : D} → N n → gcd zero (succ n) ∣ succ n
{-# ATP prove gcd-0S-∣₂ ∣-refl-S #-}

---------------------------------------------------------------------------
-- 'gcd (succ m) 0 ∣ 0'.

postulate gcd-S0-∣₂ : {m : D} → N m → gcd (succ m) zero ∣ zero
{-# ATP prove gcd-S0-∣₂ zN #-}

---------------------------------------------------------------------------
-- 'gcd (succ m) (succ n) ∣ succ n' when 'succ m ≤ succ n'.

{- Proof:
1. gcd Sm (Sn - Sm) | (Sn - Sm)        IH
2  gcd Sm (Sn - Sm) | Sm               gcd-∣₁
3. gcd Sm (Sn - Sm) | (Sn - Sm) + Sm   m∣n→m∣o→m∣n+o 1,2
4. Sm ≤ Sn                             Hip
5. gcd (Sm - Sn) Sn | Sm               arith-gcd-m≤n₂ 3,4
6. gcd Sm Sn = gcd Sm (Sn - Sm)        gcd eq. 4
7. gcd Sm Sn | Sn                      subst 5,6
-}

-- For the proof using the ATP we added the auxiliar hypothesis:
-- 1. gcd (succ m) (succ n - succ m) ∣ (succ n - succ m) + succ m.
-- 2 (succ n - succ m) + succ m ≡ succ n.

postulate
  gcd-S≤S-∣₂-ah :
    {m n : D} → N m → N n →
    (gcd (succ m) (succ n - succ m) ∣ (succ n - succ m)) →
    (gcd (succ m) (succ n - succ m) ∣ succ m) →
    LE (succ m) (succ n) →
    (gcd (succ m) (succ n - succ m) ∣ (succ n - succ m) + succ m) →
    ( (succ n - succ m) + succ m ≡ succ n ) →
    gcd (succ m) (succ n) ∣ succ n
{-# ATP prove gcd-S≤S-∣₂-ah #-}

gcd-S≤S-∣₂ :
  {m n : D} → N m → N n →
  (gcd (succ m) (succ n - succ m) ∣ (succ n - succ m)) →
  (gcd (succ m) (succ n - succ m) ∣ succ m) →
  LE (succ m) (succ n) →
  gcd (succ m) (succ n) ∣ succ n
gcd-S≤S-∣₂ {m} {n} Nm Nn ih gcd-∣₁ Sm≤Sn =
  gcd-S≤S-∣₂-ah Nm Nn ih gcd-∣₁ Sm≤Sn
    (x∣y→x∣z→x∣y+z gcd-Sm,Sn-Sm-N Sn-Sm-N (sN Nm) ih gcd-∣₁)
    (x≤y→y-x+x≡y (sN Nm) (sN Nn) Sm≤Sn)

  where
  Sn-Sm-N : N (succ n - succ m)
  Sn-Sm-N = minus-N (sN Nn) (sN Nm)

  gcd-Sm,Sn-Sm-N : N (gcd (succ m) (succ n - succ m) )
  gcd-Sm,Sn-Sm-N = gcd-N (sN Nm) Sn-Sm-N (λ p → ⊥-elim (¬S≡0 (∧-proj₁ p)))

---------------------------------------------------------------------------
-- 'gcd (succ m) (succ n) ∣ succ n' when 'succ m > succ n'.

postulate
  gcd-S>S-∣₂ :
    {m n : D} → N m → N n →
    (gcd (succ m - succ n) (succ n) ∣ succ n) →
    GT (succ m) (succ n) →
    gcd (succ m) (succ n) ∣ succ n
{-# ATP prove gcd-S>S-∣₂ #-}

---------------------------------------------------------------------------
-- The gcd is CD
---------------------------------------------------------------------------

-- We will prove that 'gcd-CD : ... → CD m n (gcd m n).

---------------------------------------------------------------------------
-- The 'gcd 0 (succ n)' is CD.

gcd-0S-CD : {n : D} → N n → CD zero (succ n) (gcd zero (succ n))
gcd-0S-CD Nn = ( gcd-0S-∣₁ Nn , gcd-0S-∣₂ Nn )

-----------------------------------------------------------------------
-- The 'gcd (succ m) 0 ' is CD.

gcd-S0-CD : {m : D} → N m → CD (succ m) zero (gcd (succ m) zero)
gcd-S0-CD Nm = ( gcd-S0-∣₁ Nm , gcd-S0-∣₂ Nm )

---------------------------------------------------------------------------
-- The 'gcd (succ m) (succ n)' when 'succ m > succ n' is CD.

gcd-S>S-CD :
  {m n : D} → N m → N n →
  (CD (succ m - succ n) (succ n) (gcd (succ m - succ n) (succ n))) →
  GT (succ m) (succ n) →
  CD (succ m) (succ n) (gcd (succ m) (succ n))
gcd-S>S-CD {m} {n} Nm Nn acc Sm>Sn =
   ( gcd-S>S-∣₁ Nm Nn acc-∣₁ acc-∣₂ Sm>Sn , gcd-S>S-∣₂ Nm Nn acc-∣₂ Sm>Sn )
  where
    acc-∣₁ : gcd (succ m - succ n) (succ n) ∣ (succ m - succ n)
    acc-∣₁ = ∧-proj₁ acc

    acc-∣₂ : gcd (succ m - succ n) (succ n) ∣ succ n
    acc-∣₂ = ∧-proj₂ acc

---------------------------------------------------------------------------
-- The 'gcd (succ m) (succ n)' when 'succ m ≤ succ n' is CD.

gcd-S≤S-CD :
  {m n : D} → N m → N n →
  (CD (succ m) (succ n - succ m) (gcd (succ m) (succ n - succ m))) →
  LE (succ m) (succ n) →
  CD (succ m) (succ n) (gcd (succ m) (succ n))
gcd-S≤S-CD {m} {n} Nm Nn acc Sm≤Sn =
  ( gcd-S≤S-∣₁ Nm Nn acc-∣₁ Sm≤Sn , gcd-S≤S-∣₂ Nm Nn acc-∣₂ acc-∣₁ Sm≤Sn )
  where
    acc-∣₁ : gcd (succ m) (succ n - succ m) ∣ succ m
    acc-∣₁ = ∧-proj₁ acc

    acc-∣₂ : gcd (succ m) (succ n - succ m) ∣ (succ n - succ m)
    acc-∣₂ = ∧-proj₂ acc

---------------------------------------------------------------------------
-- The 'gcd m n' when 'm > n' is CD

-- N.B. If '>' were an inductive data type, we would use the absurd pattern
-- to prove the second case.

gcd-x>y-CD :
  {m n : D} → N m → N n →
  ({m' n' : D} → N m' → N n' → LT₂ (m' , n') (m , n) →
       ¬ ((m' ≡ zero) ∧ (n' ≡ zero)) → CD m' n' (gcd m' n')) →
  GT m n →
  ¬ ((m ≡ zero) ∧ (n ≡ zero)) → CD m n (gcd m n)

gcd-x>y-CD zN zN _ _ ¬0≡0∧0≡0   = ⊥-elim $ ¬0≡0∧0≡0 (refl , refl)
gcd-x>y-CD zN (sN Nn) _ 0>Sn _  = ⊥-elim (¬0>x (sN Nn) 0>Sn)
gcd-x>y-CD (sN Nm) zN _ _  _    = gcd-S0-CD Nm
gcd-x>y-CD (sN {m} Nm) (sN {n} Nn) allAcc Sm>Sn _  =
  gcd-S>S-CD Nm Nn ih Sm>Sn
  where
    -- Inductive hypothesis.
    ih : CD (succ m - succ n) (succ n) (gcd (succ m - succ n) (succ n))
    ih  = allAcc {succ m - succ n}
                 {succ n}
                 (minus-N (sN Nm) (sN Nn))
                 (sN Nn)
                 (Sx>Sy→[Sx-Sy,Sy]<₂[Sx,Sy] Nm Nn Sm>Sn )
                 (λ p → ⊥-elim $ ¬S≡0 $ ∧-proj₂ p )

---------------------------------------------------------------------------
-- The 'gcd m n' when 'm ≤ n' is CD.

-- N.B. If '≤' were an inductive data type, we would use the absurd pattern
-- to prove the third case.

gcd-x≤y-CD :
  {m n : D} → N m → N n →
  ({m' n' : D} → N m' → N n' → LT₂ (m' , n') (m , n)
       → ¬ ((m' ≡ zero) ∧ (n' ≡ zero)) → CD m' n' (gcd m' n')) →
  LE m n →
  ¬ ((m ≡ zero) ∧ (n ≡ zero)) → CD m n (gcd m n)

gcd-x≤y-CD zN zN _ _ ¬0≡0∧0≡0   = ⊥-elim $ ¬0≡0∧0≡0 (refl , refl)
gcd-x≤y-CD zN (sN Nn) _ _ _     = gcd-0S-CD Nn
gcd-x≤y-CD (sN _ ) zN _ Sm≤0 _  = ⊥-elim $ ¬S≤0 Sm≤0
gcd-x≤y-CD (sN {m} Nm) (sN {n} Nn) allAcc Sm≤Sn _ =
  gcd-S≤S-CD Nm Nn ih Sm≤Sn
  where
    -- Inductive hypothesis
    ih : CD (succ m) (succ n - succ m)  (gcd (succ m) (succ n - succ m))
    ih = allAcc {succ m}
                {succ n - succ m}
                (sN Nm)
                (minus-N (sN Nn) (sN Nm))
                (Sx≤Sy→[Sx,Sy-Sx]<₂[Sx,Sy] Nm Nn Sm≤Sn)
                (λ p → ⊥-elim $ ¬S≡0 $ ∧-proj₁ p )

---------------------------------------------------------------------------
-- The 'gcd' is CD.

gcd-CD : {m n : D} → N m → N n → ¬ ((m ≡ zero) ∧ (n ≡ zero)) →
         CD m n (gcd m n)
gcd-CD = wf₂-indN P istep
  where
    P : D → D → Set
    P i j = ¬ ((i ≡ zero) ∧ (j ≡ zero)) → CD i j  (gcd i j )

    istep :
      {i j : D} → N i → N j →
      ({i' j' : D} → N i' → N j' → LT₂ (i' , j') (i , j) → P i' j') →
      P i j
    istep Ni Nj allAcc =
      [ gcd-x>y-CD Ni Nj allAcc ,  gcd-x≤y-CD Ni Nj allAcc ] (x>y∨x≤y Ni Nj )
