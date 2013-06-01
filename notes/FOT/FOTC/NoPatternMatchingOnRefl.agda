------------------------------------------------------------------------------
-- Proving properties without using pattern matching on refl
------------------------------------------------------------------------------

{-# OPTIONS --no-universe-polymorphism #-}
{-# OPTIONS --without-K #-}

module FOT.FOTC.NoPatternMatchingOnRefl where

open import FOTC.Base
open import FOTC.Base.List

open import FOTC.Data.Bool
open import FOTC.Data.Conat
open import FOTC.Data.Conat.Equality
open import FOTC.Data.List
open import FOTC.Data.Nat
open import FOTC.Data.Nat.Inequalities
open import FOTC.Data.Stream

open import FOTC.Program.McCarthy91.McCarthy91

open import FOTC.Relation.Binary.Bisimilarity

------------------------------------------------------------------------------
-- From FOTC.Base.PropertiesI

-- Congruence properties

·-leftCong : ∀ {a b c} → a ≡ b → a · c ≡ b · c
·-leftCong {a} {c = c} h = subst (λ t → a · c ≡ t · c) h refl

·-rightCong : ∀ {a b c} → b ≡ c → a · b ≡ a · c
·-rightCong {a} {b} h = subst (λ t → a · b ≡ a · t) h refl

·-cong : ∀ {a b c d} → a ≡ b → c ≡ d → a · c ≡ b · d
·-cong {a} {c = c} h₁ h₂ = subst₂ (λ t₁ t₂ → a · c ≡ t₁ · t₂) h₁ h₂ refl

succCong : ∀ {m n} → m ≡ n → succ₁ m ≡ succ₁ n
succCong {m} h = subst (λ t → succ₁ m ≡ succ₁ t) h refl

predCong : ∀ {m n} → m ≡ n → pred₁ m ≡ pred₁ n
predCong {m} h = subst (λ t → pred₁ m ≡ pred₁ t) h refl

ifCong₁ : ∀ {b₁ b₂ d e} → b₁ ≡ b₂ → if b₁ then d else e ≡ if b₂ then d else e
ifCong₁ {b₁} {d = d} {e} h =
  subst (λ t → if b₁ then d else e ≡ if t then d else e) h refl

ifCong₂ : ∀ {b d₁ d₂ e} → d₁ ≡ d₂ → if b then d₁ else e ≡ if b then d₂ else e
ifCong₂ {b} {d₁} {e = e} h =
  subst (λ t → if b then d₁ else e ≡ if b then t else e) h refl

ifCong₃ : ∀ {b d e₁ e₂} → e₁ ≡ e₂ → if b then d else e₁ ≡ if b then d else e₂
ifCong₃ {b} {d} {e₁} h =
  subst (λ t → if b then d else e₁ ≡ if b then d else t) h refl

------------------------------------------------------------------------------
-- From FOTC.Base.List.PropertiesI

-- Congruence properties

∷-leftCong : ∀ {x y xs} → x ≡ y → x ∷ xs ≡ y ∷ xs
∷-leftCong {x} {xs = xs} h = subst (λ t → x ∷ xs ≡ t ∷ xs) h refl

∷-rightCong : ∀ {x xs ys} → xs ≡ ys → x ∷ xs ≡ x ∷ ys
∷-rightCong {x}{xs} h = subst (λ t → x ∷ xs ≡ x ∷ t) h refl

∷-Cong : ∀ {x y xs ys} → x ≡ y → xs ≡ ys → x ∷ xs ≡ y ∷ ys
∷-Cong {x} {xs = xs} h₁ h₂ = subst₂ (λ t₁ t₂ → x ∷ xs ≡ t₁ ∷ t₂) h₁ h₂ refl

headCong : ∀ {xs ys} → xs ≡ ys → head₁ xs ≡ head₁ ys
headCong {xs} h = subst (λ t → head₁ xs ≡ head₁ t) h refl

tailCong : ∀ {xs ys} → xs ≡ ys → tail₁ xs ≡ tail₁ ys
tailCong {xs} h = subst (λ t → tail₁ xs ≡ tail₁ t) h refl

------------------------------------------------------------------------------
-- From FOTC.Data.Bool.PropertiesI

-- Congruence properties

&&-leftCong : ∀ {a b c} → a ≡ b → a && c ≡ b && c
&&-leftCong {a} {c = c} h = subst (λ t → a && c ≡ t && c) h refl

&&-rightCong : ∀ {a b c} → b ≡ c → a && b ≡ a && c
&&-rightCong {a} {b} h = subst (λ t → a && b ≡ a && t) h refl

&&-cong : ∀ {a b c d } → a ≡ c → b ≡ d → a && b ≡ c && d
&&-cong {a} {b} h₁ h₂ = subst₂ (λ t₁ t₂ → a && b ≡ t₁ && t₂) h₁ h₂ refl

notCong : ∀ {a b} → a ≡ b → not a ≡ not b
notCong {a} h = subst (λ t → not a ≡ not t) h refl

------------------------------------------------------------------------------
-- FOTC.Data.Conat.Equality.PropertiesI

≈N-refl : ∀ {n} → Conat n → n ≈N n
≈N-refl {n} Cn = ≈N-coind R prf₁ prf₂
  where
  R : D → D → Set
  R a b = Conat a ∧ Conat b ∧ a ≡ b

  prf₁ : ∀ {a b} → R a b →
         a ≡ zero ∧ b ≡ zero
         ∨ (∃[ a' ] ∃[ b' ] a ≡ succ₁ a' ∧ b ≡ succ₁ b' ∧ R a' b')
  prf₁ (Ca , Cb , h) with Conat-unf Ca
  ... | inj₁ prf              = inj₁ (prf , trans (sym h) prf)
  ... | inj₂ (a' , prf , Ca') =
    inj₂ (a' , a' , prf , trans (sym h) prf , (Ca' , Ca' , refl))

  prf₂ : Conat n ∧ Conat n ∧ n ≡ n
  prf₂ = Cn , Cn , refl

≡→≈N : ∀ {m n} → Conat m → Conat n → m ≡ n → m ≈N n
≡→≈N {m} Cm _ h = subst (λ t → m ≈N t) h (≈N-refl Cm)

------------------------------------------------------------------------------
-- FOTC.Data.List.PropertiesI

-- Congruence properties

++-leftCong : ∀ {xs ys zs} → xs ≡ ys → xs ++ zs ≡ ys ++ zs
++-leftCong {xs} {zs = zs} h = subst (λ t → xs ++ zs ≡ t ++ zs) h refl

++-rightCong : ∀ {xs ys zs} → ys ≡ zs → xs ++ ys ≡ xs ++ zs
++-rightCong {xs} {ys} h = subst (λ t → xs ++ ys ≡ xs ++ t) h refl

mapCong₂ : ∀ {f xs ys} → xs ≡ ys → map f xs ≡ map f ys
mapCong₂ {f} {xs} h = subst (λ t → map f xs ≡ map f t) h refl

revCong₁ : ∀ {xs ys zs} → xs ≡ ys → rev xs zs ≡ rev ys zs
revCong₁ {xs} {zs = zs} h = subst (λ t → rev xs zs ≡ rev t zs) h refl

revCong₂ : ∀ {xs ys zs} → ys ≡ zs → rev xs ys ≡ rev xs zs
revCong₂ {xs} {ys} h = subst (λ t → rev xs ys ≡ rev xs t) h refl

reverseCong : ∀ {xs ys} → xs ≡ ys → reverse xs ≡ reverse ys
reverseCong {xs} h = subst (λ t → reverse xs ≡ reverse t) h refl

lengthCong : ∀ {xs ys} → xs ≡ ys → length xs ≡ length ys
lengthCong {xs} h = subst (λ t → length xs ≡ length t) h refl

------------------------------------------------------------------------------
-- From FOTC.Data.Nat.Inequalities.PropertiesI

-- Congruence properties

leLeftCong : ∀ {m n o} → m ≡ n → le m o ≡ le n o
leLeftCong {m} {o = o} h = subst (λ t → le m o ≡ le t o) h refl

ltLeftCong : ∀ {m n o} → m ≡ n → lt m o ≡ lt n o
ltLeftCong {m} {o = o} h = subst (λ t → lt m o ≡ lt t o) h refl

ltRightCong : ∀ {m n o} → n ≡ o → lt m n ≡ lt m o
ltRightCong {m} {n} h = subst (λ t → lt m n ≡ lt m t) h refl

ltCong : ∀ {m₁ n₁ m₂ n₂} → m₁ ≡ m₂ → n₁ ≡ n₂ → lt m₁ n₁ ≡ lt m₂ n₂
ltCong {m₁} {n₁} h₁ h₂ = subst₂ (λ t₁ t₂ → lt m₁ n₁ ≡ lt t₁ t₂) h₁ h₂ refl

------------------------------------------------------------------------------
-- From FOTC.Data.Nat.PropertiesI

-- Congruence properties

+-leftCong : ∀ {m n o} → m ≡ n → m + o ≡ n + o
+-leftCong {m} {o = o} h = subst (λ t → m + o ≡ t + o) h refl

+-rightCong : ∀ {m n o} → n ≡ o → m + n ≡ m + o
+-rightCong {m} {n} h = subst (λ t → m + n ≡ m + t) h refl

∸-leftCong : ∀ {m n o} → m ≡ n → m ∸ o ≡ n ∸ o
∸-leftCong {m} {o = o} h = subst (λ t → m ∸ o ≡ t ∸ o) h refl

∸-rightCong : ∀ {m n o} → n ≡ o → m ∸ n ≡ m ∸ o
∸-rightCong {m} {n} h = subst (λ t → m ∸ n ≡ m ∸ t) h refl

*-leftCong : ∀ {m n o} → m ≡ n → m * o ≡ n * o
*-leftCong {m} {o = o} h = subst (λ t → m * o ≡ t * o) h refl

*-rightCong : ∀ {m n o} → n ≡ o → m * n ≡ m * o
*-rightCong {m} {n} h = subst (λ t → m * n ≡ m * t) h refl

------------------------------------------------------------------------------
-- From FOTC.Relation.Binary.Bisimilarity.PropertiesI

≈-refl : ∀ {xs} → Stream xs → xs ≈ xs
≈-refl {xs} Sxs = ≈-coind R prf₁ prf₂
  where
  R : D → D → Set
  R xs ys = Stream xs ∧ xs ≡ ys

  prf₁ : ∀ {xs ys} → R xs ys → ∃[ x' ] ∃[ xs' ] ∃[ ys' ]
         xs ≡ x' ∷ xs' ∧ ys ≡ x' ∷ ys' ∧ R xs' ys'
  prf₁ (Sxs , h) with Stream-unf Sxs
  ... | x' , xs' , h₁ , Sxs' =
    x' , xs' , xs' , h₁ , subst (λ t → t ≡ x' ∷ xs') h h₁ , (Sxs' , refl)

  prf₂ : R xs xs
  prf₂ = Sxs , refl

------------------------------------------------------------------------------
-- From FOT.FOTC.Data.Stream.Equality.PropertiesI where

stream-≡→≈ : ∀ {xs ys} → Stream xs → Stream ys → xs ≡ ys → xs ≈ ys
stream-≡→≈ {xs} Sxs _ h = subst (λ t → xs ≈ t) h (≈-refl Sxs)

------------------------------------------------------------------------------
-- From FOTC.Program.McCarthy91.AuxiliaryPropertiesATP

f₉₁-x≡y : ∀ {m n o} → f₉₁ m ≡ n → o ≡ m → f₉₁ o ≡ n
f₉₁-x≡y {n = n} h₁ h₂ = subst (λ t → f₉₁ t ≡ n) (sym h₂) h₁
