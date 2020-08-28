function z = zcr(x)
z = sign(abs(diff(sign(x))));
return
end