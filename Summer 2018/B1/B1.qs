namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
 
    operation Solve (qs : Qubit[]) : Int
    {
        body
        {
            for (i in 0..Length(qs) - 2) {
                CNOT(qs[i], qs[Length(qs) - 1]);
            }
            let result =  M(qs[Length(qs)-1]);
            if (result == One){
                return 1;
            }
            else {
                return 0;
            }
        }
    }

}