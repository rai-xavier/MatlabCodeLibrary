function mystring = NUM2STR_ZEROPAD(mynum, numzeros)
myformat = ['%0' num2str(numzeros) '.f'];
mystring = num2str(mynum,myformat);
return
end