(* Tested with Coq 8.3 *)

Require Import Coq.Unicode.Utf8.

Axiom D    : Set.
Axiom nil  : D.
Axiom cons : D → D → D.
Axiom node : D → D → D.

Inductive Forest : D → Set :=
| nilF  : Forest nil
| consF : forall (t ts : D), TreeT t → Forest ts → Forest (cons t ts)

with TreeT : D → Set :=
| treeT : forall (d ts : D), Forest ts → TreeT (node d ts).

Fixpoint countT (t : D) (Tt : TreeT t) {struct Tt} : nat :=
  match Tt with
    treeT d ts Fts =>
      match Fts with
        | nilF               => 0
        | consF x xs Tx Fxs => countT _ Tx
        (* | consF x xs Tx Fxs => countT _ (treeT d xs Fxs) *)
      end
  end.
