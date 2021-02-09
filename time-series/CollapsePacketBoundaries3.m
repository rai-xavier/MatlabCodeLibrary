function pktboundscollapsed = CollapsePacketBoundaries3(pkts,minseparation)
numpkts = size(pkts,1);
% start w/ 1st pkt
pktboundscollapsed = pkts(1,:);
% first (potential) collapse begins w/ 2nd pkt
pktidx = 2;
while pktidx <= numpkts
    pktgap = pkts(pktidx,1) - pktboundscollapsed(end,2);
    
    % next pkt start too close from last pkt end
    if pktgap <= minseparation
        % update last pkt end
        pktboundscollapsed(end,2) = pkts(pktidx,2);
        % update pktidx
        pktidx = pktidx + 1;
        
    % next pkt start far enough from last pkt end
    else
        % update next pkt
        pktboundscollapsed(end+1,:) = pkts(pktidx,:);
        % update pktidx
        pktidx = pktidx + 1;
        
    end
    
end

return
end