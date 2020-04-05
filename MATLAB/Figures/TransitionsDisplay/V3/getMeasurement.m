function[LevelsG, LevelsP, Measurement] = getMeasurement(G, MeasurementSequence, Worst, Levels, GeomOrientation)
if MeasurementSequence
    if Levels == 3
        %Get the initial ground and excited state populations statuses
        LevelsG = G.Levels3G;
        LevelsP = G.Levels3P;
        if Worst
            Measurement = G.ThreeWorstMeasurement;
        else
            Measurement = G.ThreeBestMeasurement;
        end
    elseif Levels == 5
        %Get the initial ground and excited state populations statuses
        LevelsG = G.Levels5G;
        LevelsP = G.Levels5P;
        if Worst
            Measurement = G.FiveWorstMeasurement;
        else
            Measurement = G.FiveBestMeasurement;
        end
    elseif Levels == 7
        %Get the initial ground and excited state populations statuses
        LevelsG = G.Levels7G;
        LevelsP = G.Levels7P;
        if Worst
            Measurement = G.SevenWorstMeasurement;
        else
            Measurement = G.SevenBestMeasurement;
        end
    end
else
    if Levels == 3 
        if GeomOrientation == "XZ" || GeomOrientation == "Average"
            LevelsG = G.Levels3G;
            LevelsP = G.Levels3G;
        elseif  GeomOrientation == "Orthogonal"
            LevelsG = G.Levels3G;
            LevelsP = G.Levels3POrthog;
        end
    elseif Levels == 5 
        if GeomOrientation == "XZ" || GeomOrientation == "Average"
            LevelsG = G.Levels5G;
            LevelsP = G.Levels5G;
        elseif  GeomOrientation == "Orthogonal"
            LevelsG = G.Levels5G;
            LevelsP = G.Levels5POrthog;
        end
    elseif Levels == 7
        if GeomOrientation == "XZ" || GeomOrientation == "Average"
            LevelsG = G.Levels7G;
            LevelsP = G.Levels7G;
        elseif  GeomOrientation == "Orthogonal"
            LevelsG = G.Levels7G;
            LevelsP = G.Levels7POrthog;
        end
    end
    Measurement = [];
end
end