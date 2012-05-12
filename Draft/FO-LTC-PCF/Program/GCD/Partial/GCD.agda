------------------------------------------------------------------------------
-- Definition of the gcd of two natural numbers using the Euclid's algorithm
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module Draft.FO-LTC-PCF.Program.GCD.Partial.GCD where

open import Draft.FO-LTC-PCF.Base
open import Draft.FO-LTC-PCF.Data.Nat
open import Draft.FO-LTC-PCF.Data.Nat.Inequalities
open import Draft.FO-LTC-PCF.Loop

------------------------------------------------------------------------------
-- In GHC <= 7.0.4 the gcd is a partial function, i.e. @gcd 0 0 =
-- undefined@.

-- Instead of define gcdh : ((D → D → D) → (D → D → D)) → D → D → D,
-- we use the LTC-PCF λ-abstraction and application to avoid use a
-- polymorphic fixed-point operator.

-- Version using λ-abstraction.

-- gcdh : D → D
-- gcdh g = lam (λ d → lam (λ e →
--            if (isZero e)
--               then (if (isZero d)
--                        then loop
--                        else d)
--               else (if (isZero d)
--                        then e
--                        else (if (gt d e)
--                                 then g · (d ∸ e) · e
--                                 else g · d · (e ∸ d)))))

-- Version using lambda-lifting via super-combinators.
-- (Hughes. Super-combinators. 1982)

gcd-helper₁ : D → D → D → D
gcd-helper₁ d g e = if (iszero₁ e)
                       then (if (iszero₁ d)
                                then loop
                                else d)
                       else (if (iszero₁ d)
                                then e
                                else (if (d > e)
                                         then g · (d ∸ e) · e
                                         else g · d · (e ∸ d)))

gcd-helper₂ : D → D → D
gcd-helper₂ g d = lam (gcd-helper₁ d g)

gcdh : D → D
gcdh g = lam (gcd-helper₂ g)

gcd : D → D → D
gcd d e = fix gcdh · d · e
