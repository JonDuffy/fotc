------------------------------------------------------------------------------
-- The booleans
------------------------------------------------------------------------------

module LTC.Data.Bool where

open import LTC.Base

infixr 6 _&&_

------------------------------------------------------------------------------
-- The LTC booleans type.
open import LTC.Data.Bool.Type public

------------------------------------------------------------------------------
-- Basic functions

-- The conjunction.
postulate
  _&&_  : D → D → D
  &&-tt : true  && true  ≡ true
  &&-tf : true  && false ≡ false
  &&-ft : false && true  ≡ false
  &&-ff : false && false ≡ false
{-# ATP axiom &&-tt #-}
{-# ATP axiom &&-tf #-}
{-# ATP axiom &&-ft #-}
{-# ATP axiom &&-ff #-}
