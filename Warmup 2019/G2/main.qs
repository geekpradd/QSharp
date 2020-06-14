namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (x : Qubit[], y : Qubit) : Unit {
        body 
        {
            // your code here
            //ApplyToEach(X, x);
            let n = Length(x);
            for (i in 0..n-1){
            	X(x[i]);
            }
            X(y);
            Controlled X(x, y);
            //ApplyToEach(X, x);
            for (i in 0..n-1){
            	X(x[i]);
            }
        }
        adjoint auto;
    }
}