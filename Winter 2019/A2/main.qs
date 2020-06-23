namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;

    operation Solve (qs : Qubit[], bits : Bool[][]) : Unit {
        // your code here
        let n = Length(qs);
        using (x = Qubit[2]){
        	H(x[0]);
        	H(x[1]);

        	X(x[0]); X(x[1]);
        	for (i in 0..n-1){
        		if (bits[0][i] == true){
        			Message("bruhh");
        			Controlled X(x, qs[i]);
        		}
        	}
        	X(x[0]);
        	for (i in 0..n-1){
        		if (bits[1][i] == true){
        			Message("bruh");
        			Controlled X(x, qs[i]);
        		}
        	}
        	X(x[1]); X(x[0]);
        	for (i in 0..n-1){
        		if (bits[2][i] == true){
        			Controlled X(x, qs[i]);
        		}
        	}
        	X(x[0]);
        	for (i in 0..n-1){
        		if (bits[3][i]){
        			Controlled X(x, qs[i]);
        		}
        	}
        	ResetAll(x);
        }
    }

    operation Main(): Unit {
    	using (q = Qubit[3]){
    		let b = [[true, true, false], [true, true, true], [false, true, true], [false, false, false]];
    		Solve(q, b);
    		DumpMachine();
    		ResetAll(q);
    	}
    }
}