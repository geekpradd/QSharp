namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (qs : Qubit[]) : Int
    {
        body
        {
            // your code here
            let n = Length(qs);
            mutable answer = 0;
            mutable zeros = 0;
            mutable ones = 0;
            for (i in 0..n-1){
            	let result = M(qs[i]);
            	if (result == One){
            		set ones = ones + 1;
            	}
            	else {
            		set zeros = zeros + 1;
            	}
            }
            if (ones == 1){
            	set answer = 1;
            }
            return answer;
        }
    }
}