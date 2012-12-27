
local i = 1
print(i)


tableA = {"jack","jilly","moon","beijing"}

for k,val in pairs(tableA) 
do 
 print(k,val) 
end

--##################

tableB = {name="jack",age="10",mark="100"}

print(tableB["name"])

for k,val in pairs(tableB) 
do 
 print(k,val) 
end

--##################

tableC = {["name"]="terry",["age"]=10,["mark"]=90}

for k ,val in pairs(tableC) do print(k,val) end

print(table.getn({10,2,3}))
print(table.getn(tableA))

--##################

--[[
print "enter a number : "

n = assert(io.read("*number"),"invalid input")
--]]

--##################

tableD = {}
table.insert(tableD,10)
print(table.getn(tableD))

--##################

lines = {
 
      luaH_set = 10,
      luaH_get = 24,
      luaH_preset = 48,
     
}

a = {}

for n in pairs(lines) 
 do
   table.insert(a,n)
 end   

table.sort(a)

for i,n in ipairs(a)
 do
   print(i,n)
 end

--##################

