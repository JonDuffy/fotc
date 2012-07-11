------------------------------------------------------------------------------
-- The types used by the mirror function
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module FOTC.Program.Mirror.Type where

open import FOTC.Base
open import FOTC.Data.List

------------------------------------------------------------------------------
-- Tree terms.
postulate
  node : D → D → D

-- The mutually totality predicates

data Forest : D → Set  -- The list of rose trees (called forest).
data Tree   : D → Set  -- The rose tree type.

data Forest where
  nilF  :                                 Forest []
  consF : ∀ {t ts} → Tree t → Forest ts → Forest (t ∷ ts)
{-# ATP axiom nilF consF #-}

data Tree where
  treeT : ∀ d {ts} → Forest ts → Tree (node d ts)
{-# ATP axiom treeT #-}

------------------------------------------------------------------------------
-- Mutual induction for Tree and Forest

-- Adapted from the induction principles generate from the Coq 8.3pl4 command
--
-- Scheme Tree_mutual_ind :=
--   Minimality for Tree Sort Prop
-- with Forest_mutual_ind :=
--   Minimality for Forest Sort Prop.

Tree-ind :
  {A B : D → Set} →
  (∀ d {ts} → Forest ts → B ts → A (node d ts)) →
  B [] →
  (∀ {t ts} → Tree t → A t → Forest ts → B ts → B (t ∷ ts)) →
  ∀ {t} → Tree t → A t

Forest-ind :
  {P B : D → Set} →
  (∀ d {ts} → Forest ts → B ts → P (node d ts)) →
  B [] →
  (∀ {t ts} → Tree t → P t → Forest ts → B ts → B (t ∷ ts)) →
  ∀ {ts} → Forest ts → B ts

Tree-ind ihA B[] _   (treeT d nilF)           = ihA d nilF B[]
Tree-ind ihA B[] ihB (treeT d (consF Tt Fts)) =
  ihA d (consF Tt Fts) (ihB Tt (Tree-ind ihA B[] ihB Tt)
                              Fts (Forest-ind ihA B[] ihB Fts))

Forest-ind _   B[] _   nilF           = B[]
Forest-ind ihP B[] ihB (consF Tt Fts) =
  ihB Tt (Tree-ind ihP B[] ihB Tt) Fts (Forest-ind ihP B[] ihB Fts)