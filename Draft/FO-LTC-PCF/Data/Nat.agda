------------------------------------------------------------------------------
-- Natural numbers (PCF version)
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module Draft.FO-LTC-PCF.Data.Nat where

open import Draft.FO-LTC-PCF.Base
open import Draft.FO-LTC-PCF.Data.Nat.Rec

-- We add 3 to the fixities of the standard library.
infixl 10 _*_
infixl 9  _+_ _∸_

------------------------------------------------------------------------------
-- The LTC-PCF natural numbers type.
open import Draft.FO-LTC-PCF.Data.Nat.Type public

------------------------------------------------------------------------------
-- Addition with recursion on the first argument.

-- Version using lambda-abstraction.
-- _+_ : D → D → D
-- m + n = rec m n (lam (λ x → lam (λ y → succ₁ y)))

-- Version using lambda lifting via super-combinators.
-- (Hughes. Super-combinators. 1982)

+-helper : D → D
+-helper _ = lam succ₁
{-# ATP definition +-helper #-}

_+_ : D → D → D
m + n = rec m n (lam +-helper)
{-# ATP definition _+_ #-}

------------------------------------------------------------------------------
-- Substraction.

-- Version using lambda-abstraction.
-- _∸_ : D → D → D
-- m ∸ n = rec n m (lam (λ x → lam (λ y → pred y)))

-- Version using lambda lifting via super-combinators.
-- (Hughes. Super-combinators. 1982)

∸-helper : D → D
∸-helper _ = lam pred₁
{-# ATP definition ∸-helper #-}

_∸_ : D → D → D
m ∸ n = rec n m (lam ∸-helper)
{-# ATP definition _∸_ #-}

------------------------------------------------------------------------------
-- Multiplication with recursion on the first argument.

-- Version using lambda-abstraction.
-- _*_ : D → D → D
-- m * n = rec m zero (lam (λ _ → lam (λ y → n + y)))

-- Version using lambda lifting via super-combinators.
-- (Hughes. Super-combinators. 1982)

*-helper₁ : D → D → D
*-helper₁ n y = n + y
{-# ATP definition *-helper₁ #-}

*-helper₂ : D → D → D
*-helper₂ n x = lam (*-helper₁ n)
{-# ATP definition *-helper₂ #-}

_*_ : D → D → D
m * n = rec m zero (lam (*-helper₂ n))
{-# ATP definition _*_ #-}
