------------------------------------------------------------------------------
-- The gcd is N
------------------------------------------------------------------------------

module LTC.Program.GCD.IsN-ATP where

open import LTC.Base
open import LTC.Base.PropertiesC using ( ¬S≡0 )

open import Common.Function using ( _$_ )

open import LTC.Data.Nat
  using ( _-_
        ; N ; sN ; zN  -- The LTC natural numbers type.
        )
open import LTC.Data.Nat.Induction.LexicographicATP using ( wfIndN-LT₂ )
open import LTC.Data.Nat.Inequalities using ( GT ; LE ; LT₂)
open import LTC.Data.Nat.Inequalities.PropertiesATP
  using ( ¬0>x
        ; ¬S≤0
        ; [Sx-Sy,Sy]<[Sx,Sy]
        ; [Sx,Sy-Sx]<[Sx,Sy]
        ; x>y∨x≤y
        )
open import LTC.Data.Nat.PropertiesATP using ( minus-N )

open import LTC.Program.GCD.Definitions using ( ¬x≡0∧y≡0 )
open import LTC.Program.GCD.GCD using ( gcd )

------------------------------------------------------------------------------
-- The 'gcd 0 (succ n)' is N.
postulate
  gcd-0S-N : {n : D} → N n → N (gcd zero (succ n))
{-# ATP prove gcd-0S-N sN #-}

------------------------------------------------------------------------------
-- The 'gcd (succ n) 0' is N.
postulate
  gcd-S0-N : {n : D} → N n → N (gcd (succ n) zero)
{-# ATP prove gcd-S0-N sN #-}

------------------------------------------------------------------------------
-- The 'gcd (succ m) (succ n)' when 'succ m > succ n' is N.
postulate
  gcd-S>S-N : {m n : D} → N m → N n →
              N (gcd (succ m - succ n) (succ n)) →
              GT (succ m) (succ n) →
              N (gcd (succ m) (succ n))
-- Metis 2.3 (release 20101019) no-success due to timeout (180 sec).
{-# ATP prove gcd-S>S-N #-}

------------------------------------------------------------------------------
-- The 'gcd (succ m) (succ n)' when 'succ m ≤ succ n' is N.
postulate
  gcd-S≤S-N : {m n : D} → N m → N n →
              N (gcd (succ m) (succ n - succ m)) →
              LE (succ m) (succ n) →
              N (gcd (succ m) (succ n))
-- Metis 2.3 (release 20101019) no-success due to timeout (180 sec).
{-# ATP prove gcd-S≤S-N #-}

------------------------------------------------------------------------------
-- The 'gcd m n' when 'm > n' is N.
-- N.B. If '>' were an inductive data type, we would use the absurd pattern
-- to prove the second case.
gcd-x>y-N :
  {m n : D} → N m → N n →
  ({o p : D} → N o → N p → LT₂ o p m n → ¬x≡0∧y≡0 o p → N (gcd o p)) →
  GT m n →
  ¬x≡0∧y≡0 m n →
  N (gcd m n)
gcd-x>y-N zN zN _ _ ¬0≡0∧0≡0   = ⊥-elim $ ¬0≡0∧0≡0 (refl , refl)
gcd-x>y-N zN (sN Nn) _ 0>Sn _  = ⊥-elim $ ¬0>x (sN Nn) 0>Sn
gcd-x>y-N (sN Nm) zN  _  _ _   = gcd-S0-N Nm
gcd-x>y-N (sN {m} Nm) (sN {n} Nn) accH Sm>Sn _ =
  gcd-S>S-N Nm Nn ih Sm>Sn
  where
    -- Inductive hypothesis.
    ih : N (gcd (succ m - succ n) (succ n))
    ih = accH {succ m - succ n}
              {succ n}
              (minus-N (sN Nm) (sN Nn))
              (sN Nn)
              ([Sx-Sy,Sy]<[Sx,Sy] Nm Nn)
              (λ p → ⊥-elim $ ¬S≡0 $ ∧-proj₂ p)

------------------------------------------------------------------------------
-- The 'gcd m n' when 'm ≤ n' is N.
-- N.B. If '≤' were an inductive data type, we would use the absurd pattern
-- to prove the third case.
gcd-x≤y-N :
  {m n : D} → N m → N n →
  ({o p : D} → N o → N p → LT₂ o p m n → ¬x≡0∧y≡0 o p → N (gcd o p)) →
  LE m n →
  ¬x≡0∧y≡0 m n →
  N (gcd m n)
gcd-x≤y-N zN zN _ _  ¬0≡0∧0≡0   = ⊥-elim $ ¬0≡0∧0≡0 (refl , refl)
gcd-x≤y-N zN (sN Nn) _ _ _      = gcd-0S-N Nn
gcd-x≤y-N (sN Nm) zN _ Sm≤0  _  = ⊥-elim $ ¬S≤0 Nm Sm≤0
gcd-x≤y-N (sN {m} Nm) (sN {n} Nn) accH Sm≤Sn _ =
  gcd-S≤S-N Nm Nn ih Sm≤Sn
  where
    -- Inductive hypothesis.
    ih : N (gcd (succ m) (succ n - succ m))
    ih = accH {succ m}
              {succ n - succ m}
              (sN Nm)
              (minus-N (sN Nn) (sN Nm))
              ([Sx,Sy-Sx]<[Sx,Sy] Nm Nn)
              (λ p → ⊥-elim $ ¬S≡0 $ ∧-proj₁ p)

------------------------------------------------------------------------------
-- The 'gcd' is N.
gcd-N : {m n : D} → N m → N n → ¬x≡0∧y≡0 m n → N (gcd m n)
gcd-N = wfIndN-LT₂ P istep
  where
    P : D → D → Set
    P i j = ¬x≡0∧y≡0 i j → N (gcd i j)

    istep :
      {i j : D} → N i → N j →
      ({k l : D} → N k → N l → LT₂ k l i j → P k l) →
      P i j
    istep Ni Nj accH =
      [ gcd-x>y-N Ni Nj accH
      , gcd-x≤y-N Ni Nj accH
      ] (x>y∨x≤y Ni Nj)
