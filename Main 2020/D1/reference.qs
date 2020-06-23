// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Kata.QuantumClassification {
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
        let auxil = [1.0, 1.0];

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

    // The definition of classifier structure for the case when the data is linearly separable and fits into 1 qubit
    function ClassifierStructure() : ControlledRotation[] {
        return new ControlledRotation[0];
    }


    // Entry point for training a model; takes the data as the input and uses hard-coded classifier structure.
    operation TrainLinearlySeparableModel(
        trainingVectors : Double[][],
        trainingLabels : Int[],
        initialParameters : Double[][]
    ) : (Double[], Double) {
        // convert training data and labels into a single data structure
        let samples = Mapped(
            LabeledSample,
            Zip(Preprocessed(trainingVectors), trainingLabels)
        );
        let (optimizedModel, nMisses) = TrainSequentialClassifier(
            Mapped(
                SequentialModel(ClassifierStructure(), _, 0.0),
                initialParameters
            ),
            samples,
            DefaultTrainingOptions()
                w/ LearningRate <- 4.0
                w/ Tolerance <- 0.0003
                w/ VerboseMessage <- Message,
            DefaultSchedule(trainingVectors),
            DefaultSchedule(trainingVectors)
        );
        Message($"Training complete, found optimal parameters: {optimizedModel::Parameters}, {optimizedModel::Bias} with {nMisses} misses");
        return (optimizedModel::Parameters, optimizedModel::Bias);
    }


    // Entry point for using the model to classify the data; takes validation data and model parameters as inputs and uses hard-coded classifier structure.
    operation ClassifyLinearlySeparableModel(
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
        let probabilities = EstimateClassificationProbabilities(
            tolerance, model,
            samples, nMeasurements
        );
        return InferredLabels(model::Bias, probabilities);
    }

    operation Validate(
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

}