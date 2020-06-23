namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // your code here
        mutable result = 0;
        using (qs = Qubit[2]){
            X(qs[0]); X(qs[1]);
            unitary(qs);
            let r = M(qs[0]);
            if (r == Zero){
                set result = 1;
            }

            ResetAll(qs);
        }
        return result;
    }
}