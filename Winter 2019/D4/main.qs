namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;

    operation Solve (qs : Qubit[]) : Unit {
        // your code here
        // this is simpler than the official!
        ApplyToEach((CNOT(Tail(qs), _)), Most(qs));
        let n = Length(qs);
        for (i in 0..n-2){
            let j = n-2-i;
            Controlled X(qs[0..j], qs[j+1]);
        }
        X(qs[0]);
        H(Tail(qs));
        ApplyToEach((CNOT(Tail(qs), _)), Most(qs));
        ApplyToEach(X, Most(qs));

    }

    operation Main(): Unit {
    	using (qs = Qubit[3]){
    		X(qs[2]);
    		Solve(qs);
    		DumpMachine();
    		ResetAll(qs);
    	}
    }
}