namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    operation Solve (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // your code here
        mutable complex = 0;
        mutable sign = 0;
        using (qs = Qubit[2]){
        	H(qs[0]);
        	for (i in 0..2){
        		Controlled unitary([qs[0]], qs[1]);
        		CNOT(qs[0], qs[1]);
        		let z = M(qs[1]);
        		Reset(qs[1]);
        		if (i == 1){
        			H(qs[0]);
        			let r = M(qs[0]);

        			if (r == One){
        				set complex = 1;
        			}
        			 Reset(qs[0]);
        			H(qs[0]);
        		}
        		if (i == 2){
        			if (complex == 1){
        				let angle = -PI()/2.0;
        				R1(angle, qs[0]);
        			}
        			H(qs[0]);
        			let r = M(qs[0]);
        			if (r == One){
        				set sign = 1;
        			}
        		}
        	}
        	ResetAll(qs);
        }
        // if (sign == 1){
        // 	Message("negative");
        // }
        // else{
        // 	Message("positive");
        // }
        if (complex == 1){
        	// Message("complex");
        	if (sign == 1){
        		return 2;
        	}
        	else {
        		return 0;
        	}
        }
        else {
        	// Message("Normal");
        	if (sign == 1){
        		return 1;
        	}
        	else {
        		return 3;
        	}
        }

    }


    operation XZ(q: Qubit): Unit is Adj+Ctl{
    	let ang = -PI();
    	Ry(ang, q);
    	// Z(q);
    	// X(q);
    }
    operation Main(): Unit {
    	let ans = Solve(XZ);
    	
    	if (ans == 0){
    		Message("right");
    	}
    }
}