namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // your code here
        mutable ans = 0;
        using (q = Qubit()){
        	unitary(q);
        	let result = M(q);
        	if (result == One){
        		set ans = 1;
        	}
        	Reset(q);
        }
        return ans;
    }
}