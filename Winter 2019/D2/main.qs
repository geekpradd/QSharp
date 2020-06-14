namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;

    operation Solve (qs : Qubit[]) : Unit {
        // your code here
        let n = Length(qs);
        for (m in 0..n-2){
        	let i = n-1-m;
        	for (j in i+1..n-1){
        		X(qs[j]);
        	}
        	for (j in 0..i-1){
        		Controlled H(qs[i..n-1], qs[j]);
        	}
        	for (j in i+1..n-1){
        		X(qs[j]);
        	}
        }
    }

    operation Main(): Unit {
    	using (qs=Qubit[4]){
    		ApplyToEach(X, Most(qs));
    		DumpMachine();
    		ResetAll(qs);
    	}
    }
}