namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;


    operation Solve (theta : Double, unitary : (Qubit => Unit is Adj+Ctl)) : Int {

        mutable iters = Floor(PI()/theta);

        mutable res = 0;
        for (count in 0..15){
        	using (q = Qubit()){
	        	for (i in 1..iters){
		        	unitary(q);
		        }

		        let r = M(q);
		        if (r == One){
		        	set res = 1;
		        }
		        Reset(q);
	        }

        }
        
        return res;
        
    }
    operation cus(q: Qubit): Unit is Adj+Ctl{
    	Ry(0.04, q);
    }

    operation Main(): Unit {
    	let z = Solve(0.04, cus);
    	if (z == 1){
    		Message("Y");
    	}
    	else {
    		Message("Z");
    	}
    }
}