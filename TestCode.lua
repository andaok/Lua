
local i = 1
print(i)


tableA = {"jack","jilly","moon","beijing"}

for k,val in pairs(tableA) 
do 
 print(k,val) 
end


tableB = {name="jack",age="10",mark="100"}

for k,val in pairs(tableB) do print(k,val) end


tableC = {["name"]="terry",["age"]=10,["mark"]=90}

for k ,val in pairs(tableC) do print(k,val) end

