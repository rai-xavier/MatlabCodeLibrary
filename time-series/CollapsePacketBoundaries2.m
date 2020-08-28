function pktboundscollapsed = CollapsePacketBoundaries2(pktbounds,minseparation,series,backgroundthresh)

pktboundscollapsed = pktbounds(1);
for i = 2:length(pktbounds)
    
    % current pkt-bound sufficient distance from last pkt-bound
    if pktbounds(i) - pktboundscollapsed(end) >= minseparation
        
        % if right bound of a packet, then make sure next data below
        % background thresh
        if mod(length(pktboundscollapsed)+1,2) == 0
            istart = pktbounds(i)+1;
            istop = istart + minseparation;
            iseg = series(istart:istop);
            if mean(iseg) <= backgroundthresh
                pktboundscollapsed(end+1) = pktbounds(i);
            end
            
        % left bound -> only needs to be far from last right bound
        else
            pktboundscollapsed(end+1) = pktbounds(i);
        end
    end
end

return
end