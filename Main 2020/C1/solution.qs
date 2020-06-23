namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;


    operation Solve (qs : Qubit[]) : Unit {
        // your code here
        ApplyToEach(X, qs);
        mutable result = Zero;
        repeat {
        	ApplyToEach(X, qs);
       		ApplyToEach(H, qs);
            using (q = Qubit()){
                Controlled X(qs, q);
                   
                set result = M(q);
               
                Reset(q);
            }
 
        }
        until (result == Zero);
    }
    operation Main(): Unit {
    	using (qs = Qubit[2]){
    		Solve(qs);
    		DumpMachine();
    		ResetAll(qs);
    	}
    }
}