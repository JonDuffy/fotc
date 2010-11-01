module BisimilarityPostFixedPoint where

-- open import LTC.Minimal
-- open import LTC.MinimalER

infixr 5 _∷_
infix 4 _≈_
infixr 4 _,_
infix  3 _≡_
infixr 2 _∧_

------------------------------------------------------------------------------
-- LTC stuff

-- The universal domain.
postulate D : Set

  -- LTC lists.
postulate
  _∷_  : D → D → D

-- The existential quantifier type on D.
data ∃D (P : D → Set) : Set where
  _,_ : (d : D) (Pd : P d) → ∃D P

∃D-proj₁ : {P : D → Set} → ∃D P → D
∃D-proj₁ (x , _ ) = x

∃D-proj₂ : {P : D → Set} → (x-px : ∃D P) → P (∃D-proj₁ x-px)
∃D-proj₂ (_ , px) = px

-- The identity type on D.
data _≡_ (x : D) : D → Set where
  refl : x ≡ x

-- Identity properties

sym : {x y : D} → x ≡ y → y ≡ x
sym refl = refl

subst : (P : D → Set){x y : D} → x ≡ y → P x → P y
subst P refl px = px

-- The conjunction data type.
data _∧_ (A B : Set) : Set where
  _,_ : A → B → A ∧ B

∧-proj₁ : {A B : Set} → A ∧ B → A
∧-proj₁ (x , y) = x

∧-proj₂ : {A B : Set} → A ∧ B → B
∧-proj₂ (x , y) = y

------------------------------------------------------------------------------

BISI : (D → D → Set) → D → D → Set
BISI R xs ys =
  ∃D (λ x' →
  ∃D (λ y' →
  ∃D (λ xs' →
  ∃D (λ ys' →
     x' ≡ y' ∧ R xs' ys' ∧ xs ≡ x' ∷ xs' ∧ ys ≡ y' ∷ ys'))))

postulate
  -- The bisimilarity relation.
  _≈_ : D → D → Set

  -- The bisimilarity relation is a post-fixed point of BISI.
  -≈-gfp₁ : {xs ys : D} → xs ≈ ys →
            ∃D (λ x' →
            ∃D (λ xs' →
            ∃D (λ ys' → xs' ≈ ys' ∧ xs ≡ x' ∷ xs' ∧ ys ≡ x' ∷ ys')))

-≈→BISI≈ : (xs ys : D) → xs ≈ ys → BISI _≈_ xs ys
-≈→BISI≈ xs ys xs≈ys =
  x' , x' , xs' , ys' , refl , xs'≈ys' , xs≡x'∷xs' , ys≡x'∷ys'
  where
    x' : D
    x' = ∃D-proj₁ (-≈-gfp₁ xs≈ys)

    xs' : D
    xs' = ∃D-proj₁ (∃D-proj₂ (-≈-gfp₁ xs≈ys))

    ys' : D
    ys' = ∃D-proj₁ (∃D-proj₂ (∃D-proj₂ (-≈-gfp₁ xs≈ys)))

    aux : xs' ≈ ys' ∧ xs ≡ x' ∷ xs' ∧ ys ≡ x' ∷ ys'
    aux = ∃D-proj₂ (∃D-proj₂ (∃D-proj₂ (-≈-gfp₁ xs≈ys)))

    xs'≈ys' : xs' ≈ ys'
    xs'≈ys' = ∧-proj₁ aux

    xs≡x'∷xs' : xs ≡ x' ∷ xs'
    xs≡x'∷xs' = ∧-proj₁ (∧-proj₂ aux)

    ys≡x'∷ys' : ys ≡ x' ∷ ys'
    ys≡x'∷ys' = ∧-proj₂ (∧-proj₂ aux)
