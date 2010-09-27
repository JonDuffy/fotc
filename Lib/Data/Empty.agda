------------------------------------------------------------------------------
-- Empty type
------------------------------------------------------------------------------

module Lib.Data.Empty where

------------------------------------------------------------------------------
-- The empty type.
data ⊥ : Set where

⊥-elim : {A : Set} → ⊥ → A
⊥-elim ()
