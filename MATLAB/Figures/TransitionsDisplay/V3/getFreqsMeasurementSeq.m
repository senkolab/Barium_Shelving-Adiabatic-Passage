function[Freqs] = getFreqsMeasurementSeq(G, Measurement, LevelsG, LevelsP, Level, CarrierFreq, GeomOrientation)

for i = 1:size(Measurement, 1)
    MeasurementStep = Measurement(i, :);
    %Type of measurement: Shelve, Deshelve, Fluoresce, Hide
    Type = MeasurementStep(1);
    MeasurementStep = str2double(MeasurementStep(2:3));
    %Catch if tried to use level that doesn't exist
    if any(MeasurementStep < 1 | MeasurementStep > 8)
        fprintf("Step number %i %s for d = %i failed. \nState number specified is out of range of possible levels.\n", i, Type, Level);
        continue
    end
    if Type == "Shelve"
        %Catch if we forgot to specify a level in a transfer
        if any(isnan(MeasurementStep))
            fprintf("Step number %i %s for d = %i failed. \nOne of the states not specified. \n", i, Type, Level);
            disp("     LevelsG    LevelsP");
            disp([LevelsG LevelsP]);
            continue;
        end
        %Get the levels involved in the transfer
        Lower = MeasurementStep(1);
        Upper = MeasurementStep(2);
        %Get the actual F values for this lower level we're depopulating
        LowerLevel = LevelsG(Lower, :);
        %Catch error of trying to transfer population that's not there
        if all(isnan(LowerLevel))
            fprintf("Step number %i %s for d = %i failed. \nThis state number %d is not populated. \n", i, Type, Level, Lower);
            disp("     LevelsG    LevelsP");
            disp([LevelsG LevelsP]);
            continue;
        end
        %Catch if we're trying to drive into an already populated state
        if ~all(isnan(LevelsP(Upper, :)))
            disp("Error 2");
            fprintf("Step number %i %s for d = %i failed. \nThe state number %d is already populated. \n", i, Type, Level);
            disp("     LevelsG    LevelsP");
            disp([LevelsG LevelsP]);
            continue;
        end
        %Set the upper level matrix entry equal to this
        LevelsP(Upper, :) = G.LevelsAll(Upper, :);
        fprintf("Shelving F=%i, mF=%i into state F'=%i, mF'=%i\n", LowerLevel(1), LowerLevel(2), LevelsP(Upper, 1), LevelsP(Upper, 2));
        if i == 1
            Freqs = GetCareFrequencies(G, LowerLevel, LevelsP(Upper,:), CarrierFreq, GeomOrientation);
        else
            Freqs = [Freqs; GetCareFrequencies(G, LowerLevel, LevelsP(Upper,:), CarrierFreq, GeomOrientation)];
        end
        %Finished transfer, make change to lower level
        LevelsG(Lower, :) = [NaN NaN];
    elseif Type == "Deshelve"
        %Catch if we forgot to specify a level in a transfer
        if any(isnan(MeasurementStep))
            fprintf("Step number %i %s for d = %i failed. \nOne of the states not specified. \n", i, Type, Level);
            disp("     LevelsG    LevelsP");
            disp([LevelsG LevelsP]);
            continue;
        end
        %Get the levels involved in the transfer
        Upper = MeasurementStep(1);
        Lower = MeasurementStep(2);
        %Get the actual F values for this upper level we're depopulating
        UpperLevel = LevelsP(Upper, :);
        %Catch error of trying to transfer population that's not there
        if all(isnan(UpperLevel))
            fprintf("Step number %i %s for d = %i failed. \nThis state number %d is not populated. \n", i, Type, Level, Lower);
            disp("     LevelsG    LevelsP");
            disp([LevelsG LevelsP]);
            continue;
        end
        %Catch if we're trying to drive into an already populated state
        if ~all(isnan(LevelsG(Lower, :)))
            fprintf("Step number %i %s for d = %i failed. \nThis state number %d is already populated. \n", i, Type, Level, Lower);
            disp("     LevelsG    LevelsP");
            disp([LevelsG LevelsP]);
            continue;
        end
        %Set the lower level matrix entry equal to this
        LevelsG(Lower, :) = G.LevelsAll(Lower, :);
        fprintf("Deshelving F'=%i, mF'=%i into state F=%i, mF=%i\n", UpperLevel(1), UpperLevel(2), LevelsG(Lower, 1), LevelsG(Lower, 2));
        Freqs = [Freqs; GetCareFrequencies(G, LevelsG(Lower,:), UpperLevel, CarrierFreq, GeomOrientation)];
        %Finished transfer, make change to upper level
        LevelsP(Upper, :) = [NaN NaN];
    elseif Type == "Hide"
        %Catch if we forgot to specify a level in a transfer
        if any(isnan(MeasurementStep))
            fprintf("Step number %i %s for d = %i failed. \nOne of the states not specified. \n", i, Type, Level);
            disp("     LevelsG    LevelsP");
            disp([LevelsG LevelsP]);
            continue;
        end
        %Get the levels involved in the transfer
        Initial = MeasurementStep(1);
        Final = MeasurementStep(2);
        %Get the actual F values for this initial level
        InitialLevel = LevelsG(Initial, :);
        %Catch error of trying to transfer population that's not there
        if all(isnan(InitialLevel))
            fprintf("Step number %i %s for d = %i failed. \nThis state number %d is not populated. \n", i, Type, Level, Lower);
            disp("     LevelsG    LevelsP");
            disp([LevelsG LevelsP]);
            continue;
        end
        %Catch if we're trying to drive into an already populated state
        if ~all(isnan(LevelsG(Final,:)))
            fprintf("Step number %i %s for d = %i failed. \nThis state number %d is already populated.\n", i, Type, Level, Lower);
            disp("     LevelsG    LevelsP");
            disp([LevelsG LevelsP]);
            continue;
        end
        %Send the population into this new state
        LevelsG(Final,:) = G.LevelsAll(Final, :);
        fprintf("Hiding F=%i, mF=%i in state F=%i, mF=%i\n", InitialLevel(1), InitialLevel(2), LevelsG(Final, 1), LevelsG(Final, 2));
        %Erase the population from the initial state
        LevelsG(Initial,:) = [NaN NaN];
    elseif Type == "Fluoresce"
        Ground = MeasurementStep(1);
        FluoresceState = LevelsG(Ground, :);
        fprintf("Fluorescing state F=%i, mF=%i\n", FluoresceState(1), FluoresceState(2));
        LevelsG(Ground, :) = [NaN NaN];
    else
        fprintf("Step number %i %s for d = %i failed. \nYou've input a measurement step name wrong. \n", i, Type, Level);
        fprintf("Make sure all steps are called ""Shelve"", ""Deshelve"", ""Hide"", or ""Fluoresce""\n");
        continue
    end
    disp("     LevelsG    LevelsP");
    disp([LevelsG LevelsP]);
    fprintf("\n");
end
end