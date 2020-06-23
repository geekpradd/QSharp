namespace Solution {
    open Microsoft.Quantum.MachineLearning;
 
    operation Solve () : ((Int, Double[]), ControlledRotation[], (Double[], Double)){
        // your code here
        return ((4, [1.0, 1.0]), [
            ControlledRotation((1, [0]), PauliY, 0),
            ControlledRotation((0, [1]), PauliY, 1),
            ControlledRotation((0, new Int[0]), PauliY, 2),
        ], ( [3.2, 0.4, 1.3]
, 0.12565000000000004
));
    }         
}