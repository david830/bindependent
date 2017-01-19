function [outputs extrapolated interpolated lo_extrapolation_dist hi_extrapolation_dist nearinterpolated] = project(inputs,plasmid_counts,chardata,rowreport)

%global projections;  % used for debugging projections, if needed

%%%%%
%%% BUG NOTE:
%%% Interpolation function is well-defined only for an element *between*
%%% two nearest neighbors, but it is possible for a point to not be
%%% between the two closest to it in a non-uniform distribution, e.g.
%%%     ----P---P--*----------------P----
%%% At the *, the two points on the left will be selected, and interpolation
%%% will not weight correctly.
%%%%%

% preprocess plasmid row means
meanps = zeros(size(chardata.plasmids,1),1);
for j = 1:size(chardata.plasmids,1),
    which = ~isnan(chardata.plasmids(j,:));
    meanps(j) = mean(chardata.plasmids(j,which),2);
end

% map each element in turn...
outputs = zeros(size(inputs));
extrapolated = zeros(size(inputs));     % detault = not interpolated
lo_extrapolation_dist = zeros(size(inputs));     % detault = not interpolated
hi_extrapolation_dist = zeros(size(inputs));     % detault = not interpolated
interpolated = zeros(size(inputs));     % detault = not interpolated
nearinterpolated = zeros(size(inputs)); % default = not near interpolated
for i=1:numel(inputs),
    % Bail out early on projection of NaNs
    if isnan(plasmid_counts(i)) || isnan(inputs(i)), outputs(i) = NaN; continue; end
    
    % first, find the closest plasmid count
    p_diffs = abs(log10(plasmid_counts(i)./meanps));
    pchoice = find(p_diffs==min(p_diffs),1);
    
    % next, find the closest match in the row
    inrow = chardata.input(pchoice,:);
    outrow = chardata.output(pchoice,:);
    if rowreport && i==1 && 0
        inrow
        outrow
    end
    plasrow = chardata.plasmids(pchoice,:);
    if sum(isnan(inrow))>0 % Can't project when there are any NaNs in the row
        outputs(i) = NaN;
    else if inputs(i) < min(inrow)
% Trying to use min-input if too low, rather than project...
            len = chardata.low_src(pchoice);
            P = polyfit(log10(inrow(1:len)),log10(outrow(1:len)),chardata.low_poly(pchoice));
%            effective_input = max([min(inrow)/10 inputs(i) 1e4]);
            effective_input = inputs(i);
            outputs(i) = 10.^max(0,polyval(P,log10(effective_input)));
            %projections(size(projections,1)+1,1:3) = [pchoice; inputs(i); outputs(i)]; % log projections
            nearinterpolated(i) = effective_input <= 10;
%        warning('Value under max; not yet interpolating');
            % Use min value if no value available, since these are repressors...
              interpolated(i)=1;
              extrapolated(i) = -1;
              lo_extrapolation_dist(i) = inrow(1) / effective_input;
%              outputs(i) = outrow(1);
        else if inputs(i) > max(inrow)
                len = chardata.high_src(pchoice)-1;
                P = polyfit(log10(inrow((end-len):end)),log10(outrow((end-len):end)),chardata.high_poly(pchoice));
                outputs(i) = 10.^max(0,polyval(P,log10(inputs(i))));
                %projections(size(projections,1)+1,1:3) = [pchoice; inputs(i); outputs(i)]; % log projections
                nearinterpolated(i) = inputs(i)/max(inrow) < 10;
                extrapolated(i) = 1;
                hi_extrapolation_dist(i) = inputs(i)/max(inrow);
%             warning('Value over max; not yet interpolating');
%             outputs(i) = outrow(numel(inrow));
            else
                in_diffs = abs(log10(inputs(i)./inrow));
%                 sortable = [in_diffs; outrow; plasrow];
%                 ordered = sortrows(sortable')';
%                 n_chosen = 2;
%                 best_in_diff = ordered(1,1:n_chosen);
%                 best_out = ordered(2,1:n_chosen);
%                 best_plas = ordered(3,1:n_chosen);
                best_id = find(in_diffs(:)==min(in_diffs),1);
                if(inputs(i)>=inrow(best_id)), best_id(2) = best_id+1; else best_id(2) = best_id-1; end;
                if(best_id(2)==0), best_id(2) = 2; end;
                if(best_id(2)>numel(inrow)), best_id(2) = best_id(1)-1; end;
                best_in_diff = in_diffs(best_id);
                best_out = outrow(best_id);
                best_plas = plasrow(best_id);
                
                if(best_in_diff(1)==0) % if perfect, take it immediately
                    outputs(i) = best_out(1)*plasmid_counts(i)/best_plas(1);
                else % interpolate
                    weights = (1./best_in_diff)/sum(1./best_in_diff);
                    outputs(i) = 10.^sum(weights.*(log10(best_out)+log10(plasmid_counts(i))-log10(best_plas)));
                end
                interpolated(i) = 1; nearinterpolated(i) = 1;
                extrapolated(i) = 0;
            end
        end
    end
end



end
