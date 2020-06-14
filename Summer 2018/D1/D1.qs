namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (x : Qubit[], y : Qubit, b : Int[]) : ()
    {
        body
        {
           let n = Length(b);
           for (i in 0..n-1){
                using (qs = Qubit[2]){
                    if (b[i] == 1){
                        X(qs[0]);
                    }
                    Controlled X([qs[0], x[i]], qs[1]);
                    CNOT(qs[1], y);
                    ResetAll(qs);
                }
           }
        }
    }
}