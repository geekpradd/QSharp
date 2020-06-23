namespace Solution {
    open Microsoft.Quantum.MachineLearning;
 
    operation Solve () : ((Int, Double[]), ControlledRotation[], (Double[], Double)){
        // your code here
        return ((1, [0.3]), [
        			ControlledRotation((0, new Int[0]), PauliI, 0)
                    ], ( [0.0], 0.0007499999999999729
));
    }         
}