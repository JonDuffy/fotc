------------------------------------------------------------------------------
-- Test the consistency of FOTC.Program.ABP.ABP
------------------------------------------------------------------------------

{-# OPTIONS --exact-split              #-}
{-# OPTIONS --no-sized-types           #-}
{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K                #-}

-- In the module FOTC.Program.ABP.ABP we declare Agda postulates as
-- first-order logic axioms. We test if it is possible to prove an
-- unprovable theorem from these axioms.

module FOTC.Program.ABP.ABP.Consistency.Axioms where

open import FOTC.Base
open import FOTC.Program.ABP.ABP

------------------------------------------------------------------------------

postulate impossible : ∀ d e → d ≡ e
{-# ATP prove impossible #-}
