namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;


    operation Solve (qs : Qubit[], parity:Int) : Unit {
        // your code here
        
        ApplyToEach(H, qs);
        using (q = Qubit()){
            ApplyToEach((CNOT(_, q)), qs);
            let r = M(q);
            if (parity == 0){
                if (r == One){
                    X(qs[0]);
                }
            }
            if (parity == 1){
                if (r == Zero){
                    X(qs[0]);
                }
            }

            Reset(q);
        }
        
        
    }
    operation Main(): Unit {
    	using (qs = Qubit[2]){
    		Solve(qs, 1);
    		DumpMachine();
    		ResetAll(qs);
    	}
    }
}