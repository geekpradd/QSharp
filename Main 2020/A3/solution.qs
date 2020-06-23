namespace Solution {
    open Microsoft.Quantum.Intrinsic;

    operation Solve (unitary : (Qubit => Unit is Adj+Ctl)) : Int {
        // your code here
        mutable answer = 1;
        using (q=Qubit()){
        	X(q);
        	unitary(q);
        	X(q);
        	unitary(q);
        	let m = M(q);
        	if (m == One){
        		set answer = 0;
        	}
        	Reset(q);
        }
        return answer;
    }
}