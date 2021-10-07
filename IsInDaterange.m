function isInRange = IsInDaterange(date, ranges)
% This function checks if some data inside the intersection range
% Returns 1 if true and 0 othewise
isInRange = 0;
for idx = 1:length(ranges)
    range = ranges(idx, :);
    if date >= range(1) && date <= range(2)
        isInRange = 1;
        break;
    end
end
end