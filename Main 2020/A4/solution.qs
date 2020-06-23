namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    operation Solve (unitary : ((Double, Qubit) => Unit is Adj+Ctl)) : Int {
        // your code here
        let angle = 8.0*ArcTan(1.0);
        mutable result = 0;
        using (q = Qubit[2]){
        	H(q[0]);
        	Controlled unitary([q[0]], (angle, q[1]));
        	let m = M(q[1]);
        	H(q[0]);
        	let mm = M(q[0]);
        	if (mm == Zero){
        		set result = 1;
        	}
        	ResetAll(q);
        }
        return result;
    }

    operation Main(): Unit {
    	using (qs = Qubit[2]){
    		let ot = Solve(Rz);
    		if (ot == 0){
    			Message("Rz");
    		}
    		else {
    			Message("Ro");
    		}
    		ResetAll(qs);
    	}
    }
}