------------------------------------------------------------------------------
-- Logical Theory of Constructions for PCF (LTC-PCF)
------------------------------------------------------------------------------

{-# OPTIONS --exact-split              #-}
{-# OPTIONS --no-sized-types           #-}
{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K                #-}

-- Code accompanying the paper "Embedding a Logical Theory of
-- Constructions in Agda" by Ana Bove, Peter Dybjer and Andrés
-- Sicard-Ramírez (PLPV'09).

-- The code presented here does not match the paper exactly.

module LTC-PCF.README where

------------------------------------------------------------------------------
-- Description

-- Formalization of (a version of) Azcel's Logical Theory of
-- Constructions for PCF.

------------------------------------------------------------------------------
-- The axioms
open import LTC-PCF.Base

-- Properties
open import LTC-PCF.Base.Properties

------------------------------------------------------------------------------
-- Booleans

-- The inductive predicate
open import LTC-PCF.Data.Bool.Type

-- Properties
open import LTC-PCF.Data.Bool.Properties

------------------------------------------------------------------------------
-- Natural numberes

-- The arithmetical functions
open import LTC-PCF.Data.Nat

-- The inductive predicate
open import LTC-PCF.Data.Nat.Type

-- Properties
open import LTC-PCF.Data.Nat.Properties

-- Divisibility relation
open import LTC-PCF.Data.Nat.Divisibility.NotBy0.Properties

-- Induction
open import LTC-PCF.Data.Nat.Induction.NonAcc.Lexicographic
open import LTC-PCF.Data.Nat.Induction.NonAcc.WF

-- Inequalites
open import LTC-PCF.Data.Nat.Inequalities.EliminationProperties
open import LTC-PCF.Data.Nat.Inequalities.Properties

-- The recursive operator
open import LTC-PCF.Data.Nat.Rec.ConversionRules

------------------------------------------------------------------------------
-- A looping combinator
open import LTC-PCF.Loop

------------------------------------------------------------------------------
-- Verification of programs

-- The division algorithm: A non-structurally recursive algorithm
open import LTC-PCF.Program.Division.CorrectnessProof

-- The GCD algorithm: A non-structurally recursive algorithm
open import LTC-PCF.Program.GCD.Partial.CorrectnessProof
open import LTC-PCF.Program.GCD.Total.CorrectnessProof
