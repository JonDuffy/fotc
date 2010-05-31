------------------------------------------------------------------------------
-- Arithmetic properties using equational reasoning
------------------------------------------------------------------------------

module LTC.Function.Arithmetic.PropertiesER where

open import LTC.Minimal
open import LTC.MinimalER

open import LTC.Data.N
open import LTC.Function.Arithmetic
open import LTC.Function.Arithmetic.Properties using ( +-comm )
open import LTC.Relation.Equalities.PropertiesER

open import MyStdLib.Function
import MyStdLib.Relation.Binary.EqReasoning
open module APER = MyStdLib.Relation.Binary.EqReasoning.StdLib _≡_ refl trans

------------------------------------------------------------------------------

minus-N : {m n : D} → N m → N n → N (m - n)
minus-N {m} Nm          zN          = subst (λ t → N t) (sym (minus-x0 m)) Nm
minus-N     zN          (sN {n} Nn) = subst (λ t → N t) (sym (minus-0S n)) zN
minus-N     (sN {m} Nm) (sN {n} Nn) = subst (λ t → N t)
                                            (sym (minus-SS m n))
                                            (minus-N Nm Nn)

minus-0x : {n : D} → N n → zero - n  ≡ zero
minus-0x zN          = minus-x0 zero
minus-0x (sN {n} Nn) = minus-0S n

+-leftIdentity : {n : D} → N n → zero + n ≡ n
+-leftIdentity {n} _ = +-0x n

+-rightIdentity : {n : D} → N n → n + zero ≡ n
+-rightIdentity zN          = +-leftIdentity zN
+-rightIdentity (sN {n} Nn) =
  trans (+-Sx n zero)
        (subst (λ t → succ (n + zero) ≡ succ t)
               (+-rightIdentity Nn)
               refl
        )

+-N : {m n : D} → N m → N n → N (m + n)
+-N zN Nn = subst (λ t → N t) (sym (+-leftIdentity Nn)) Nn
+-N {n = n} (sN {m} Nm ) Nn =
  subst (λ t → N t) (sym (+-Sx m n)) (sN (+-N Nm Nn))

+-assoc : {m n o : D} → N m → N n → N o → m + n + o ≡ m + (n + o)
+-assoc {n = n} {o = o} zN Nn No =
  begin
    zero + n + o ≡⟨ subst (λ t → zero + n + o ≡ t + o)
                          (+-leftIdentity Nn)
                          refl
                 ⟩
    n + o        ≡⟨ sym (+-leftIdentity (+-N Nn No)) ⟩
    zero + (n + o)
  ∎

+-assoc {n = n} {o = o} (sN {m} Nm) Nn No =
  begin
    succ m + n + o     ≡⟨ subst (λ t → succ m + n + o ≡ t + o)
                                (+-Sx m n)
                                refl
                       ⟩
    succ (m + n) + o   ≡⟨ +-Sx (m + n) o ⟩
    succ (m + n + o)   ≡⟨ subst (λ t → succ (m + n + o) ≡ succ t)
                                (+-assoc Nm Nn No)
                                refl
                       ⟩
    succ (m + (n + o)) ≡⟨ sym (+-Sx m (n + o)) ⟩
    succ m + (n + o)
  ∎

[x+y]-[x+z]≡y-z : {m n o : D} → N m → N n → N o →
                  (m + n) - (m + o) ≡ n - o
[x+y]-[x+z]≡y-z {n = n} {o} zN Nn No =
  begin
    (zero + n) - (zero + o) ≡⟨ subst (λ t → (zero + n) - (zero + o) ≡
                                            t - (zero + o))
                                      (+-0x n) refl
                            ⟩
     n - (zero + o)         ≡⟨ subst (λ t → n - (zero + o) ≡ n - t)
                                     (+-0x o)
                                     refl ⟩
    n - o
  ∎

[x+y]-[x+z]≡y-z {n = n} {o} (sN {m} Nm) Nn No =
  begin
    (succ m + n) - (succ m + o) ≡⟨ subst (λ t → succ m + n - (succ m + o) ≡
                                                t - (succ m + o))
                                         (+-Sx m n)
                                         refl
                                ⟩
    succ (m + n) - (succ m + o) ≡⟨ subst (λ t → succ (m + n) - (succ m + o) ≡
                                                succ (m + n) - t)
                                         (+-Sx m o)
                                         refl ⟩
    succ (m + n) - succ (m + o) ≡⟨ minus-SS (m + n) (m + o) ⟩
    (m + n) - (m + o) ≡⟨ [x+y]-[x+z]≡y-z Nm Nn No ⟩
    n - o
  ∎

*-leftZero : {n : D} → N n → zero * n ≡ zero
*-leftZero {n} _ = *-0x n

*-N : {m n : D} → N m → N n → N (m * n)
*-N zN Nn = subst (λ t → N t) (sym (*-leftZero Nn)) zN
*-N {n = n} (sN {m} Nm) Nn =
  subst (λ t → N t) (sym (*-Sx m n)) (+-N Nn (*-N Nm Nn))

*-rightZero : {n : D} → N n → n * zero ≡ zero
*-rightZero zN          = *-leftZero zN
*-rightZero (sN {n} Nn) =
  trans (*-Sx n zero)
        (trans (+-leftIdentity (*-N Nn zN)) (*-rightZero Nn))

x*1+y≡x+xy : {m n : D} → N m → N n → m * succ n ≡ m + m * n
x*1+y≡x+xy {n = n} zN Nn = sym
  (
    begin
      zero + zero * n ≡⟨ subst (λ t → zero + zero * n ≡ zero + t)
                         (*-leftZero Nn)
                         refl
                      ⟩
      zero + zero     ≡⟨ +-leftIdentity zN ⟩
      zero            ≡⟨ sym (*-leftZero (sN Nn)) ⟩
      zero * succ n
    ∎
  )

x*1+y≡x+xy {n = n} (sN {m} Nm) Nn =
  begin
    succ m * succ n        ≡⟨ *-Sx m (succ n) ⟩
    succ n + m * succ n    ≡⟨ subst (λ t → succ n + m * succ n ≡ succ n + t)
                                    (x*1+y≡x+xy Nm Nn)
                                    refl
                           ⟩
    succ n + (m + m * n)   ≡⟨ +-Sx n (m + m * n) ⟩
    succ (n + (m + m * n)) ≡⟨ subst (λ t → succ (n + (m + m * n)) ≡ succ t)
                                    (sym (+-assoc Nn Nm (*-N Nm Nn)))
                                    refl
                           ⟩
    succ (n + m + m * n)   ≡⟨ subst (λ t → succ (n + m + m * n) ≡
                                           succ (t + m * n))
                                    (+-comm Nn Nm)
                                    refl
                           ⟩
     succ (m + n + m * n)  ≡⟨ subst (λ t → succ (m + n + m * n) ≡ succ t)
                                    (+-assoc Nm Nn (*-N Nm Nn))
                                    refl
                           ⟩

    succ (m + (n + m * n)) ≡⟨ sym (+-Sx m (n + m * n)) ⟩
    succ m + (n + m * n)   ≡⟨ subst (λ t → succ m + (n + m * n) ≡ succ m + t)
                                    (sym (*-Sx m n))
                                    refl
                           ⟩
    succ m + succ m * n
    ∎

*-comm : {m n : D} → N m → N n → m * n ≡ n * m
*-comm zN Nn = trans (*-leftZero Nn) (sym (*-rightZero Nn))
*-comm {n = n} (sN {m} Nm) Nn =
  begin
    succ m * n   ≡⟨ *-Sx m n ⟩
    n + m * n    ≡⟨ subst (λ t → n + m * n ≡ n + t)
                          (*-comm Nm Nn)
                          refl
                  ⟩
    n + n * m     ≡⟨ sym (x*1+y≡x+xy Nn Nm) ⟩
    n * succ m
  ∎

[x-y]z≡xz*yz : {m n o : D} → N m → N n → N o → (m - n) * o ≡ m * o - n * o
[x-y]z≡xz*yz {m} {o = o} Nm zN No =
  begin
    (m - zero) * o   ≡⟨ subst (λ t → (m - zero) * o ≡ t * o)
                              (minus-x0 m)
                              refl
                      ⟩
    m * o            ≡⟨ sym (minus-x0 (m * o)) ⟩
    m * o - zero     ≡⟨ subst (λ t → m * o - zero ≡ m * o - t)
                              (sym (*-0x o))
                              refl
                     ⟩
    m * o - zero * o
  ∎

[x-y]z≡xz*yz {o = o} zN (sN {n} Nn) No =
  begin
    (zero - succ n) * o  ≡⟨ subst (λ t → (zero - succ n) * o ≡ t * o)
                                  (minus-0S n)
                                  refl
                         ⟩
    zero * o             ≡⟨ *-0x o ⟩
    zero                 ≡⟨ sym (minus-0x (*-N (sN Nn) No)) ⟩
    zero - succ n * o    ≡⟨ subst (λ t → zero - succ n * o ≡ t - succ n * o)
                                   (sym (*-0x o))
                                   refl
                         ⟩
    zero * o - succ n * o
  ∎

[x-y]z≡xz*yz (sN {m} Nm) (sN {n} Nn) zN =
  begin
    (succ m - succ n) * zero      ≡⟨ *-comm (minus-N (sN Nm) (sN Nn)) zN ⟩
    zero * (succ m - succ n)      ≡⟨ *-0x (succ m - succ n) ⟩
    zero                          ≡⟨ sym (minus-0x (*-N (sN Nn) zN)) ⟩
    zero - succ n * zero          ≡⟨ subst (λ t → zero - succ n * zero ≡
                                                  t - succ n * zero)
                                           (sym (*-0x (succ m)))
                                           refl
                                  ⟩
    zero * succ m - succ n * zero ≡⟨ subst
                                       (λ t → zero * succ m - succ n * zero ≡
                                              t - succ n * zero)
                                       (*-comm zN (sN Nm))
                                       refl
                                  ⟩
    succ m * zero - succ n * zero
  ∎

[x-y]z≡xz*yz (sN {m} Nm) (sN {n} Nn) (sN {o} No) =
  begin
    (succ m - succ n) * succ o  ≡⟨ subst (λ t → (succ m - succ n) * succ o ≡
                                                t * succ o)
                                         (minus-SS m n)
                                         refl
                                ⟩
    (m - n) * succ o            ≡⟨ [x-y]z≡xz*yz Nm Nn (sN No) ⟩
    m * succ o - n * succ o     ≡⟨ sym ([x+y]-[x+z]≡y-z (sN No)
                                                        (*-N Nm (sN No))
                                                        (*-N Nn (sN No)))
                                ⟩
    (succ o + m * succ o) - (succ o + n * succ o)
      ≡⟨ subst (λ t → (succ o + m * succ o) - (succ o + n * succ o) ≡
                      t - (succ o + n * succ o))
               (sym (*-Sx m (succ o)))
               refl
      ⟩
    (succ m * succ o) - (succ o + n * succ o)
      ≡⟨ subst (λ t → (succ m * succ o) - (succ o + n * succ o) ≡
                      (succ m * succ o) - t)
               (sym (*-Sx n (succ o)))
               refl
      ⟩
    (succ m * succ o) - (succ n * succ o)
  ∎

[x+y]z≡xz*yz : {m n o : D} → N m → N n → N o → (m + n) * o ≡ m * o + n * o
[x+y]z≡xz*yz {m} {n} Nm Nn zN =
  begin
    (m + n) * zero       ≡⟨ *-comm (+-N Nm Nn) zN ⟩
    zero * (m + n)       ≡⟨ *-0x (m + n) ⟩
    zero                 ≡⟨ sym (*-0x m) ⟩
    zero * m             ≡⟨ *-comm zN Nm ⟩
    m * zero             ≡⟨ sym (+-rightIdentity (*-N Nm zN)) ⟩
    m * zero + zero      ≡⟨ subst (λ t → m * zero + zero ≡ m * zero + t)
                                  (trans (sym (*-0x n)) (*-comm zN Nn))
                                  refl
                         ⟩
    m * zero + n * zero
  ∎

[x+y]z≡xz*yz {n = n} zN Nn (sN {o} No) =
  begin
    (zero + n) * succ o  ≡⟨ subst (λ t → (zero + n) * succ o ≡ t * succ o)
                                  (+-leftIdentity Nn)
                                  refl
                         ⟩
    n * succ o           ≡⟨ sym (+-leftIdentity (*-N Nn (sN No))) ⟩
    zero + n * succ o    ≡⟨ subst (λ t → zero + n * succ o ≡ t +  n * succ o)
                                (sym (*-0x (succ o)))
                                refl
                         ⟩
    zero * succ o + n * succ o
  ∎

[x+y]z≡xz*yz (sN {m} Nm) zN (sN {o} No) =
 begin
    (succ m + zero) * succ o ≡⟨ subst (λ t → (succ m + zero) * succ o ≡
                                             t * succ o)
                                      (+-rightIdentity (sN Nm))
                                      refl
                              ⟩
    succ m * succ o          ≡⟨ sym (+-rightIdentity (*-N (sN Nm) (sN No))) ⟩
    succ m * succ o + zero   ≡⟨ subst (λ t → succ m * succ o + zero ≡
                                             succ m * succ o + t)
                                      (sym (*-leftZero (sN No)))
                                      refl
                             ⟩
    succ m * succ o + zero * succ o
  ∎

[x+y]z≡xz*yz (sN {m} Nm) (sN {n} Nn) (sN {o} No) =
  begin
    (succ m + succ n) * succ o
      ≡⟨ subst (λ t → (succ m + succ n) * succ o ≡ t * succ o)
               (+-Sx m (succ n))
               refl
      ⟩
    succ ( m + succ n) * succ o ≡⟨ *-Sx (m + succ n) (succ o) ⟩
    succ o + (m + succ n) * succ o
      ≡⟨ subst (λ t → succ o + (m + succ n) * succ o ≡ succ o + t)
               ([x+y]z≡xz*yz Nm (sN Nn) (sN No))
               refl
      ⟩
    succ o + (m * succ o + succ n * succ o)
      ≡⟨ sym (+-assoc (sN No) (*-N Nm (sN No)) (*-N (sN Nn) (sN No))) ⟩
    succ o + m * succ o + succ n * succ o
      ≡⟨ subst (λ t → succ o + m * succ o + succ n * succ o ≡
                      t + succ n * succ o)
               (sym (*-Sx m (succ o)))
               refl
      ⟩
    succ m * succ o + succ n * succ o
      ∎