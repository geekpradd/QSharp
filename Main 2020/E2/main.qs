namespace Solution {
	open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    // Testing on bell state as it is not an eigenvector
    operation makeBell(qs: Qubit[]): Unit is Adj+Ctl{
    	X(qs[0]);
    	H(qs[0]);
    	CNOT(qs[0], qs[1]);
    	// X(qs[0]);
    }
    operation GetPhase(inputRegister: LittleEndian, anc: Qubit[]): Unit is Adj+Ctl{
    	H(anc[0]); 
    	H(anc[1]);

    	Controlled QFTLE([anc[0]], inputRegister);
    	Controlled QFTLE([anc[1]], inputRegister);
    	Controlled QFTLE([anc[1]], inputRegister);
    	let reg = LittleEndian(anc);
    	
    	Adjoint QFTLE(reg);
    }

    operation Solve (p : Int, inputRegister : LittleEndian) : Unit is Adj+Ctl{
        // your code here
        using (anc = Qubit[2]){
        	GetPhase(inputRegister, anc);

        	R1(PI()/IntAsDouble(p), anc[1]);
        	R1(PI()/IntAsDouble(2*p), anc[0]);
        	Adjoint GetPhase(inputRegister, anc);
        	
        }
    }

    // Below is the apparatus for testing
    operation Main(): Unit {
    	using (qs = Qubit[2]){
    		makeBell(qs);
    		//X(qs[0]);
    		// H(qs[0]);
            let reg = LittleEndian(qs);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            // QFTLE(reg);
            // QuantumFourierTransform_Reference(qs, 1);
            // QuantumFourierTransform_Reference(qs, 1);
            DumpMachine();
            ResetAll(qs);
        }
    }
}