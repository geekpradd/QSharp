namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (qs : Qubit[]) : Unit {
        // your code here
        let n = Length(qs);
        H(qs[0]);
        for (i in 2..n-1){
        	H(qs[i]);
        }
    }
}
