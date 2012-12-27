
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

local x = os.clock()
print("now elapsed time",x)

local s = 0

for i=1,10000000 do s = s + i end

print(string.format("elapsed time : %.2f\n",os.clock()-x))

--##################

-- vid = userid(4) + videoid(3)
-- pid = pid(4)
-- [a-zA-Z0-9]

vid = "Fay7JL5"
pid = "GfK6"

key1 = vid.."_"..pid.."_".."0"
key2 = vid.."_"..pid.."_".."X"
key3 = vid.."_"..pid.."_".."Y"
key4 = vid.."_"..pid.."_".."X0"
key5 = vid.."_"..pid.."_".."1"
key6 = vid.."_"..pid.."_".."P"
key7 = vid.."_"..pid.."_".."C"
key8 = vid.."_"..pid.."_".."L1"
key9 = vid.."_"..pid.."_".."X1"

keys = {key1,key2,key3,key4,key5,key6,key7,key8,key9}


a,b,c,d,e = string.find(key1,"(.*)_(.*)_(.*)")

print(key1)
print(a,b,c,d,e)

if string.len(c) == 7  then 
  UserId = string.sub(c,1,4)
  FileId = string.sub(c,5,-1)
  print(UserId,FileId) 
else
  print(c,"not is vid")
end 





