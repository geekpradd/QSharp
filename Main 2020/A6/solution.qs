namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation makeBell(qs: Qubit[]): Unit is Adj+Ctl{
    	H(qs[0]);
    	CNOT(qs[0], qs[1]);
    }
    operation Solve (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // your code here
        mutable first = 0;
        mutable second = 0;
        mutable ans = 0;
        using (qs = Qubit[2]){
        	makeBell(qs);
        	unitary(qs[1]);
        	Adjoint makeBell(qs);
        	let m = M(qs[0]);
        	if (m == One){
        		set first = 1;
        	}
        	let mm = M(qs[1]);
        	if (mm == One){
        		set second = 1;
        	}

        	ResetAll(qs);
        }
        if (first == 1){
        	set ans = ans + 2;
        }
        if (second == 1){
        	set ans = ans + 1;
        }
        if (ans == 2){
        	set ans = 3;
        }
        elif (ans == 3){
        	set ans = 2;
        }

        return ans;
    }


    operation Main(): Unit {
    	let r = Solve(Z);
    	if (r == 0){
    		Message("I");
    	}
    	elif (r==1){
    		Message("X");
    	}
    	elif (r==2){
    		Message("Y");
    	}
    	else {
    		Message("Z");
    	}
    }
}