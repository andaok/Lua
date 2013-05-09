
function test(a,b,c)
   print(a)
   print(b)
   print(c)
end

test(1)

key="ghdjjkl_hjui_L7890"
a,b,vid,pid,flag = string.find(key,"(.*)_(.*)_(.*)")
Num = string.sub(flag,2)
print(Num)
