namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Math;

    operation Solve (q : Qubit) : Int
    {
        body
        {
          mutable ans = -1;
          using (x = Qubit()){
          	H(x);
          	let result = M(x);
          	if (result == One){
          		Ry(ArcCos(0.0), q);
          		let r = M(q);
          		if (r == Zero){
          			set ans = 0;
          		}
          	}
          	else {
          		let r = M(q);
          		if (r == One){
          			set ans = 1;
          		}
          	}

          	Reset(x);
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
    		elif (ans == 1) {
    			Message("One");
    		}
    		else {
    			Message("uncertain");
    		}
    		Reset(q);
    	}
    }
}