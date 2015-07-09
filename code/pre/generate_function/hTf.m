function v4=hTf(v,info,type)
switch type
    case 'mean'
        v2=mean(reshape(v,2,length(v)/2));
    case 'sum'
        v2=sum(reshape(v,2,length(v)/2));
end
v4=v2(1:info.tmax);
end