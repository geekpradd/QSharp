namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (qs : Qubit[]) : Int
    {
        body
        {
            // your code here
            H(qs[0]); H(qs[1]);
            mutable answer = 0;
            let result = M(qs[0]);
            if (result == One){
            	set answer = answer + 2;
            }
            let r = M(qs[1]);
            if (r == One){
            	set answer = answer + 1;
            }
            return answer;
        }
    }
}