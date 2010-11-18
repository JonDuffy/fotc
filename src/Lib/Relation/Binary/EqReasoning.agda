-----------------------------------------------------------------------------
-- Equality reasoning
-----------------------------------------------------------------------------

module Lib.Relation.Binary.EqReasoning
  {A     : Set}
  ( _≡_  : A → A → Set)
  (refl  : {x : A} → x ≡ x)
  (trans : {x y z : A} → x ≡ y → y ≡ z → x ≡ z)
  where

infix 7 _≃_

private
  data _≃_ (x y : A) : Set where
    prf : x ≡ y → x ≃ y

------------------------------------------------------------------------------
-- From the Ulf's thesis.

module Original where

  infix  5 chain>_
  infixl 5 _===_by_
  infix  4 _qed

  chain>_ : (x : A) → x ≃ x
  chain> x = prf (refl {x})

  _===_by_ : {x y : A} → x ≃ y → (z : A) → y ≡ z → x ≃ z
  prf p === z by q = prf (trans {_} {_} {_} p q)

  _qed : {x y : A} → x ≃ y → x ≡ y
  prf p qed = p

------------------------------------------------------------------------------
-- From the standard library (Relation.Binary.PreorderReasoning).

module StdLib where

  infix  4 begin_
  infixr 5 _≡⟨_⟩_
  infix  5 _∎

  begin_ : {x y : A} → x ≃ y → x ≡ y
  begin prf x≡y = x≡y

  _≡⟨_⟩_ : (x : A){y z : A} → x ≡ y → y ≃ z → x ≃ z
  _ ≡⟨ x≡y ⟩ prf y≡z = prf (trans x≡y y≡z)

  _∎ : (x : A) → x ≃ x
  _∎ _ = prf refl
