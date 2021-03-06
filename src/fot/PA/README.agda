------------------------------------------------------------------------------
-- First-order Peano arithmetic
------------------------------------------------------------------------------

{-# OPTIONS --exact-split              #-}
{-# OPTIONS --no-sized-types           #-}
{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K                #-}

module PA.README where

------------------------------------------------------------------------------
-- Description

-- Two formalizations of first-order Peano arithmetic using axioms and
-- inductive definitions.

------------------------------------------------------------------------------
-- Axiomatic PA
open import PA.Axiomatic.Standard.README

-- Inductive PA
open import PA.Inductive.README
