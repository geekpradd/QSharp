namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // your code here
        mutable l = 0;
        using (qs = Qubit[2]){
        	X(qs[1]);
        	unitary(qs);
        	let r = M(qs[0]);
        	if (r == One){
        		set l = 1;
        	}
        	ResetAll(qs);
        }
        mutable ans = 0;
        if (l == 0){
        	using (qs = Qubit[2]){
        		X(qs[0]); X(qs[1]);
        		unitary(qs);
        		let r = M(qs[1]);
        		if (r == Zero){
        			set ans = 1;
        		}
        		ResetAll(qs);
        	}
        }
        else {
        	using (qs = Qubit[2]){
        		X(qs[1]); X(qs[0]);
        		unitary(qs);
        		let r = M(qs[0]);
        		if (r == Zero){
        			set ans = 2;
        		}
        		else {
        			set ans = 3;
        		}
        		ResetAll(qs);
        	}
        }

        return ans;	
    }
}