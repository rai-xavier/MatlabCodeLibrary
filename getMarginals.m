function [Recall,Precision,F1] = getMarginals(confmat)
Recall = [];
Precision = [];
F1 = [];
for kk=1:size(confmat,1)
    TP = confmat(kk,kk);
    Recall(kk) = round(100* (TP / sum(confmat(:,kk))), 2);
    Precision(kk) = round(100* (TP / sum(confmat(kk,:))), 2);
    F1(kk) = 2*Recall(kk)*Precision(kk) / ( Recall(kk) + Precision(kk) );
end
return
end