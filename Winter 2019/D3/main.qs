namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;

    operation Solve (qs : Qubit[]) : Unit {
        // your code here
        ApplyToEach((CNOT(Tail(qs), _)), Most(qs));
        H(Tail(qs));
        ApplyToEach((CNOT(Tail(qs), _)), Most(qs));
    }

    operation Main(): Unit {
    	using (qs = Qubit[4]){
    		X(qs[1]); X(qs[0]); X(qs[2]); 
    		Solve(qs);
    		DumpMachine();
    		ResetAll(qs);
    	}
    }
}