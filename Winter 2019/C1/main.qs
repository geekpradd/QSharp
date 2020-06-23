namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (x : Qubit[], y : Qubit) : Unit {
        body (...) {
            // your code here
            let n = Length(x);
            for (i in 0..n-2){
            	CNOT(x[i+1], x[i]);
            }
          	Controlled X(x[0..n-2], y);
          	for (i in 0..n-2){
          		let index = n-2-i;
          		CNOT(x[index+1], x[index]);
          	}
          	
        }
        adjoint auto;
    }
    operation Main(): Unit {
    	using ((qs, q) = (Qubit[3], Qubit())){
    		X(qs[0]); 
    		Solve(qs, q);
    		let result = M(q);
    		if (result == One){
    			Message("One");
    		}
    		else {
    			Message("Zero");
    		}
    		ResetAll(qs);
    		Reset(q);
    	}
    }
}