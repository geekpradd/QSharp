namespace Solution {
    open Microsoft.Quantum.MachineLearning;
 
    operation Solve () : ((Int, Double[]), ControlledRotation[], (Double[], Double)){
        // your code here
        return ((4, [1.0, 1.0]), [
        ControlledRotation((0, [1]), PauliX, 0),
        ControlledRotation((1, [0]), PauliX, 1),
        ControlledRotation((0, [1]), PauliX, 2)
                    ], ( [3.1415, 3.1415, 3.1415], 0.1377
));
    }         
}