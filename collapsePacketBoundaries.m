
function idx_pkts_collapsed = collapsePacketBoundaries(idx_pkts,grace_period)

collapsed_start = idx_pkts(1,1);
proposed_stop = idx_pkts(1,2);
idx_pkts_collapsed = [];
jj = 2; numrows = size(idx_pkts,1);
while jj <= numrows
    
        % next packet within grace period
        if ( idx_pkts(jj,2) - proposed_stop ) <= grace_period
            proposed_stop = idx_pkts(jj,2);

        % append and update with beginning of next packet
        else
            idx_pkts_collapsed = [ idx_pkts_collapsed; collapsed_start proposed_stop ];
            collapsed_start = idx_pkts(jj,1);
            proposed_stop = idx_pkts(jj,2);
        end
        
        if jj == numrows
            idx_pkts_collapsed = [ idx_pkts_collapsed; collapsed_start proposed_stop ];
        end
        jj = jj + 1;

end

return
end