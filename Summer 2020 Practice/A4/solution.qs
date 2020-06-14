namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (unitary : (Qubit[] => Unit is Adj+Ctl)) : Int {
        // your code here
        mutable ans = 1;
        using (qs = Qubit[2]){
            unitary(qs);
        	let result = M(qs[1]);
        	if (result == One){
        		set ans = 0;
        	}
        	ResetAll(qs);
        }
        return ans;
    }
}