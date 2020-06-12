namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (qs : Qubit[]) : ()
    {
        body
        {
            // your code here
            for (qubit in qs){
            	H(qubit);
            }
        }
    }

    operation Main(): () {
    	body
    	{
	    	using (register = Qubit[8]){
	    		Solve(register);
	    		ResetAll(register);
	    	}
	    }
    }

}