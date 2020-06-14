namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (x : Qubit[], y : Qubit) : Unit {
        body (...) {
        	let n = Length(x);
        	let mid = n/2;
        	for (i in 0..mid-1){
        		CNOT(x[n-1-i], x[i]);
        		X(x[i]);
        	}
        	Controlled X(x[0..mid-1], y);
        	for (i in 0..mid-1){
        		X(x[i]);
        		CNOT(x[n-1-i], x[i]);
        	}
        }
        adjoint auto;
    }
}