------------------------------------------------------------------------------
-- Axiomatic PA properties
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module PA.Axiomatic.Standard.PropertiesI where

open import Common.FOL.Relation.Binary.EqReasoning

open import PA.Axiomatic.Standard.Base

------------------------------------------------------------------------------
-- Congruence properties

succ-cong : ∀ {m n} → m ≡ n → succ m ≡ succ n
succ-cong = cong succ

+-leftCong : ∀ {m n o} → m ≡ n → m + o ≡ n + o
+-leftCong h = cong₂ _+_ h refl

+-rightCong : ∀ {m n o} → n ≡ o → m + n ≡ m + o
+-rightCong = cong₂ _+_ refl

------------------------------------------------------------------------------

+-rightIdentity : ∀ n → n + zero ≡ n
+-rightIdentity = PA-ind A A0 is
  where
  A : M → Set
  A i = i + zero ≡ i

  A0 : A zero
  A0 = PA₃ zero

  is : ∀ i → A i → A (succ i)
  is i ih = succ i + zero   ≡⟨ PA₄ i zero ⟩
            succ (i + zero) ≡⟨ succ-cong ih ⟩
            succ i          ∎

+-asocc : ∀ m n o → m + n + o ≡ m + (n + o)
+-asocc m n o = PA-ind A A0 is m
  where
  A : M → Set
  A i = i + n + o ≡ i + (n + o)

  A0 : A zero
  A0 = zero + n + o   ≡⟨ +-leftCong (PA₃ n) ⟩
       n + o          ≡⟨ sym (PA₃ (n + o)) ⟩
       zero + (n + o) ∎

  is : ∀ i → A i → A (succ i)
  is i ih = succ i + n + o     ≡⟨ +-leftCong (PA₄ i n) ⟩
            succ (i + n) + o   ≡⟨ PA₄ (i + n) o ⟩
            succ (i + n + o)   ≡⟨ succ-cong ih ⟩
            succ (i + (n + o)) ≡⟨ sym (PA₄ i (n + o)) ⟩
            succ i + (n + o)   ∎

x+Sy≡S[x+y] : ∀ m n → m + succ n ≡ succ (m + n)
x+Sy≡S[x+y] m n = PA-ind A A0 is m
  where
  A : M → Set
  A i = i + succ n ≡ succ (i + n)

  A0 : A zero
  A0 = zero + succ n   ≡⟨ PA₃ (succ n) ⟩
       succ n          ≡⟨ succ-cong (sym (PA₃ n)) ⟩
       succ (zero + n) ∎

  is : ∀ i → A i → A (succ i)
  is i ih = succ i + succ n     ≡⟨ PA₄ i (succ n) ⟩
            succ (i + succ n)   ≡⟨ succ-cong ih ⟩
            succ (succ (i + n)) ≡⟨ succ-cong (sym (PA₄ i n)) ⟩
            succ (succ i + n)   ∎

+-comm : ∀ m n → m + n ≡ n + m
+-comm m n = PA-ind A A0 is m
  where
  A : M → Set
  A i = i + n ≡ n + i

  A0 : A zero
  A0 = zero + n ≡⟨ PA₃ n ⟩
       n        ≡⟨ sym (+-rightIdentity n) ⟩
       n + zero ∎

  is : ∀ i → A i → A (succ i)
  is i ih = succ i + n   ≡⟨ PA₄ i n ⟩
            succ (i + n) ≡⟨ succ-cong ih ⟩
            succ (n + i) ≡⟨ sym (x+Sy≡S[x+y] n i) ⟩
            n + succ i   ∎
