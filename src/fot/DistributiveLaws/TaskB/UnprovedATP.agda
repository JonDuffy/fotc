------------------------------------------------------------------------------
-- Distributive laws on a binary operation: Task B
------------------------------------------------------------------------------

{-# OPTIONS --exact-split              #-}
{-# OPTIONS --no-sized-types           #-}
{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K                #-}

module DistributiveLaws.TaskB.UnprovedATP where

open import DistributiveLaws.Base

------------------------------------------------------------------------------
-- 06 January 2016: The ATPs could not prove the theorem (240 sec).
postulate
  prop₂ : ∀ u x y z →
          (x · y · (z · u)) · ((x · y · (z · u)) · (x · z · (y · u))) ≡
            x · z · (y · u)
{-# ATP prove prop₂ #-}
