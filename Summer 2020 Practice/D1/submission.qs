namespace Solution {
    open Microsoft.Quantum.MachineLearning;
 
    operation Solve () : (ControlledRotation[], (Double[], Double)) {
        // your code here
        return ([
            ControlledRotation((0, new Int[0]), PauliY, 0),
        ], ( [1.0000000000000123], 0.25065000000000004));
    }         
}