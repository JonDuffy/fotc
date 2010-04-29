-----------------------------------------------------------------------------
-- The sum (disjoint unions) data type
-----------------------------------------------------------------------------

module MyStdLib.Data.Sum where

infixr 1 _∨_

data _∨_ (A B : Set) : Set where
  inj₁ : (x : A) → A ∨ B
  inj₂ : (y : B) → A ∨ B

[_,_] : {A B C : Set} → (A → C) → (B → C) → A ∨ B → C
[ f , g ] (inj₁ x) = f x
[ f , g ] (inj₂ y) = g y
