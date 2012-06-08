------------------------------------------------------------------------------
-- The Booleans
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module FOTC.Data.Bool where

open import FOTC.Base

-- We add 3 to the fixities of the standard library.
infixr 9 _&&_

------------------------------------------------------------------------------
-- The FOTC Booleans type (inductive predicate for total Booleans).
open import FOTC.Data.Bool.Type public

------------------------------------------------------------------------------
-- Basic functions

-- The conjunction.
postulate
  _&&_  : D → D → D
  &&-tt : true  && true  ≡ true
  &&-tf : true  && false ≡ false
  &&-ft : false && true  ≡ false
  &&-ff : false && false ≡ false
{-# ATP axiom &&-tt &&-tf &&-ft &&-ff #-}

-- The negation.
not : D → D
not x = if x then false else true
{-# ATP definition not #-}