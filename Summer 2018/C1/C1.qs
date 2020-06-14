namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;

    operation Solve (q : Qubit) : Int
    {
        body
        {
            // your code here
            Ry(ArcTan(1.0), q);
            let result = M(q);
            mutable ans = 0;
            if (result == One){
            	set ans = 1;
            }
            return ans;
        }
    }

    operation Main(): Unit {
    	using (q = Qubit()){
    		let ans = Solve(q);
    		if (ans == 0){
    			Message("Zero");
    		}
    		else {
    			Message("One");
    		}
    		Reset(q);
    	}
    }
}