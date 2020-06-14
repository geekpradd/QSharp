namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // your code here
        mutable ans = 0;
        using (qs = Qubit[2]){
            H(qs[1]);
            CNOT(qs[1], qs[0]);
            Controlled unitary([qs[0]], qs[1]);
            CNOT(qs[1], qs[0]);
            let r = M(qs[0]);
            H(qs[1]);
            let result = M(qs[1]);
            if (result == Zero){
                set ans = 1;
            }
            ResetAll(qs);
        }
        return ans;
    }

  
}