namespace Microsoft.Quantum.Samples {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.MachineLearning;
    open Microsoft.Quantum.Math;


    function RawFeatures (auxil : Double[], input : Double[]) : Double[] {
        return input;
    }


    // mode 1 is feature padding: the parameters array is appended to the features array (padding on the left)
    // the length of the result is len(auxil) + len(input)
    function LeftPaddedFeatures (auxil : Double[], input : Double[]) : Double[] {
        return auxil + input;
    }


    // mode 2 is tensor product of the parameters array with input:
    // [auxil[0] * input[0], auxil[0] * input[1], auxil[1] * input[0], auxil[1] * input[1]]
    // the length of the result is len(auxil) * len(input)
    function FeaturesTensorWithAncilla (auxil : Double[], input : Double[]) : Double[] {
        mutable ret = new Double[Length(auxil) * Length(input)];
        for (j in 0 .. Length(auxil) - 1) {
            for (k in 0 .. Length(input) - 1) {
                set ret w/= (j * Length(input) + k) <- (auxil[j] * input[k]);   
            }
        }
        return ret;
    }

    // mode 3 is feature fanout: tensor product of the parameters array with input with input
    // the length of the result is len(auxil) * len(input)^2
    function FeaturesFanout (auxil : Double[], input : Double[]) : Double[] {
        mutable ret = new Double[Length(auxil)*Length(input)*Length(input)];
        for (j in 0..Length(auxil)-1) {
            for (k in 0..Length(input)-1) {
                for (m in 0..Length(input)-1) {
                    set ret w/= (j*Length(input)*Length(input)+k*Length(input)+m) <- (auxil[j] * input[k] * input[m]);   
                }
            }
        }
        return ret;    
    }

    // mode 4 is tensor product of (concatenation of left halves of parameters and input) and (concatenation of right halves)
    // [auxil[0] * auxil[1], auxil[0] * input[1], input[0] * auxil[1], input[0] * input[1]]
    // the length of the result is len(auxil) * len(input)
    function FeaturesSplitFanout (auxil : Double[], input : Double[]) : Double[] {
        let halfLa = Length(auxil)/2;
        let halfLi = Length(input)/2;
        let left = auxil[...(halfLa-1)] + input[...(halfLi-1)];
        let right = auxil[halfLa...] + input[halfLi...];
        return FeaturesTensorWithAncilla(left, right);
    }


    // a helper function to choose and apply the necessary feature engineering mode
    function FeaturesPreprocess (mode : Int, auxil : Double[], input : Double[]) : Double[] {
        if (mode == 1) { return LeftPaddedFeatures(auxil, input); }
        if (mode == 2) { return FeaturesTensorWithAncilla(auxil, input); }
        if (mode == 3) { return FeaturesFanout(auxil, input); }
        if (mode == 4) { return FeaturesSplitFanout(auxil, input); }
        // in case of unsupported mode, return the raw features
        return input;
    }

    function WithProductKernel(scale : Double, sample : Double[]) : Double[] {
        return sample + [scale * Fold(TimesD, 1.0, sample)];
    }

    function Preprocessed(samples : Double[][]) : Double[][] {
        let auxil = [0.0, 0.0];

        return Mapped(
            FeaturesPreprocess(4, auxil, _),
            samples
        );
    }

    function DefaultSchedule(samples : Double[][]) : SamplingSchedule {
        return SamplingSchedule([
            0..Length(samples) - 1
        ]);
    }

    function ClassifierStructure() : ControlledRotation[] {
        return [
            ControlledRotation((1, [0]), PauliX, 0),
            ControlledRotation((1, new Int[0]), PauliX, 1),
            ControlledRotation((0, new Int[0]), PauliX, 2)
        ];
    }
    operation TrainModel (
    trainingVectors : Double[][],
    trainingLabels : Int[],
    initialParameters : Double[][]
) : (Double[], Double) {
    // Combine training data and labels into a single data structure
    let samples = Mapped(
        LabeledSample,
        Zip(trainingVectors, trainingLabels)
    );
    
    // Define a set of models we're going to try training;
    // in this case all models have the same structure but differ in the value of initial parameters
    let models = Mapped(
        SequentialModel(ClassifierStructure(), _, 0.0),
        initialParameters
    );
    
    // use all samples both for training and for validation
    let defaultSchedule = SamplingSchedule([0..Length(samples) - 1]);
    let (optimizedModel, nMisses) = TrainSequentialClassifier(
        models,
        samples,
        DefaultTrainingOptions()
            w/ LearningRate <- 5.0  
            w/ MaxEpochs <- 4
            w/ Tolerance <- 0.0005
            w/ VerboseMessage <- Message,
        defaultSchedule,
        defaultSchedule
    );
    Message($"Training complete, found optimal parameters: {optimizedModel::Parameters}, {optimizedModel::Bias} with {nMisses} misses");
    return (optimizedModel::Parameters, optimizedModel::Bias);
}

    operation TrainHalfMoonModel(
        trainingVectors : Double[][],
        trainingLabels : Int[],
        initialParameters : Double[][]
    ) : (Double[], Double) {
        let samples = Mapped(
            LabeledSample,
            Zip(Preprocessed(trainingVectors), trainingLabels)
        );
        Message("Ready to train.");
        let (optimizedModel, nMisses) = TrainSequentialClassifier(
            Mapped(
                SequentialModel(ClassifierStructure(), _, 0.0),
                initialParameters
            ),
            samples,
            DefaultTrainingOptions()
                w/ LearningRate <- 4.0
                w/ MinibatchSize <- 15
                w/ Tolerance <- 0.005
                w/ NMeasurements <- 10000
                w/ MaxEpochs <- 5
                w/ VerboseMessage <- Message,
            DefaultSchedule(trainingVectors),
            DefaultSchedule(trainingVectors)
        );
        Message($"Training complete, found optimal parameters: {optimizedModel::Parameters}");
        return (optimizedModel::Parameters, optimizedModel::Bias);
    }

    operation ValidateHalfMoonModel(
        validationVectors : Double[][],
        validationLabels : Int[],
        parameters : Double[],
        bias : Double
    ) : Double {
        let samples = Mapped(
            LabeledSample,
            Zip(Preprocessed(validationVectors), validationLabels)
        );
        let tolerance = 0.005;
        let nMeasurements = 10000;
        let results = ValidateSequentialClassifier(
            SequentialModel(ClassifierStructure(), parameters, bias),
            samples,
            tolerance,
            nMeasurements,
            DefaultSchedule(validationVectors)
        );
        return IntAsDouble(results::NMisclassifications) / IntAsDouble(Length(samples));
    }

    operation ClassifyHalfMoonModel(
        samples : Double[][],
        parameters : Double[],
        bias : Double,
        tolerance  : Double,
        nMeasurements : Int
    )
    : Int[] {
        let model = Default<SequentialModel>()
            w/ Structure <- ClassifierStructure()
            w/ Parameters <- parameters
            w/ Bias <- bias;
        let features = Preprocessed(samples);
        let probabilities = EstimateClassificationProbabilities(
            tolerance, model,
            features, nMeasurements
        );
        return InferredLabels(model::Bias, probabilities);
    }

}