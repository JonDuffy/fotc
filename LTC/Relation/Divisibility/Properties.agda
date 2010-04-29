------------------------------------------------------------------------------
-- Properties of the divisibility relation
------------------------------------------------------------------------------

module LTC.Relation.Divisibility.Properties where

open import LTC.Minimal

open import LTC.Data.N
open import LTC.Function.Arithmetic
open import LTC.Function.Arithmetic.Postulates
open import LTC.Function.Arithmetic.Properties
open import LTC.Relation.Divisibility
open import LTC.Relation.Equalities.Properties

open import MyStdLib.Function

------------------------------------------------------------------------------
-- Any positive number divides 0.

postulate S∣0 : {n : D} → N n →  succ n ∣ zero
{-# ATP prove S∣0 zN #-}

------------------------------------------------------------------------------
-- The divisibility relation is reflexive for positive numbers.

-- For the proof using the ATP we added the auxiliar hypothesis
-- N (succ zero).
postulate ∣-refl-S-ah : {n : D} → N n → N (succ zero) → succ n ∣ succ n
{-# ATP prove ∣-refl-S-ah sN *-leftIdentity #-}

∣-refl-S : {n : D} → N n → succ n ∣ succ n
∣-refl-S Nn = ∣-refl-S-ah Nn (sN zN)

------------------------------------------------------------------------------
-- 0 doesn't divide any number.
0∤x : {d : D} → ¬ (zero ∣ d)
0∤x ( 0≠0 , _ ) = ⊥-elim $ 0≠0 refl

------------------------------------------------------------------------------
-- If 'x' divides 'y' and 'z' then 'x' divides 'y - z'.
-- For the proof using the ATP we added the auxiliar hypothesis
-- (k₁ - k₂) * succ m ≡ (k₁ * succ m) - (k₂ * succ m).
postulate
  x∣y→x∣z→x∣y-z-ah : {m n p k₁ k₂ : D} →
                      n ≡ k₁ * succ m →
                      p ≡ k₂ * succ m →
                      (k₁ - k₂) * succ m ≡ (k₁ * succ m) - (k₂ * succ m) →
                      n - p ≡ (k₁ - k₂) * succ m
{-# ATP prove x∣y→x∣z→x∣y-z-ah #-}

x∣y→x∣z→x∣y-z : {m n p : D} → N m → N n → N p → m ∣ n → m ∣ p → m ∣ n - p
x∣y→x∣z→x∣y-z zN _ _ ( 0≠0 , _) m∣p = ⊥-elim (0≠0 refl)
x∣y→x∣z→x∣y-z (sN Nm) _ _
              ( 0≠0 , ( k₁ , Nk₁ , n≡k₁Sm ))
              ( _   , ( k₂ , Nk₂ , p≡k₂Sm )) =
  (λ S≡0 → ⊥-elim (¬S≡0 S≡0)) ,
  (k₁ - k₂) ,
  minus-N Nk₁ Nk₂ ,
  x∣y→x∣z→x∣y-z-ah n≡k₁Sm p≡k₂Sm ([x-y]z≡xz*yz Nk₁ Nk₂ (sN Nm))
