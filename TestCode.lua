local cjson = require "cjson"

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

if (string.len(c) == 7 and string.len(d) == 4) and (string.len(e) == 1 or string.len(e) == 2) then 
  UserId = string.sub(c,1,4)
  FileId = string.sub(c,5,-1)
  print(UserId,FileId)

  Pid , Flag = d , e
  print(Pid,Flag)

  if e == "0" then
     print(e,": is suc play start")
  elseif e == "X" then
     print(e,": is load player fail")
  elseif e == "Y" then
     print(e,": is start check flow")
  elseif e == "X0" then
     print(e,": is play video fail")
  elseif e == "P" then
     print(e,": is log playtime info")
  end

else
  print(key,"not is vid")
end 

-- #####################

abc = "{key=1,key2=2}"
lua = "return " ..abc     
local func = loadstring(lua) 
 
cdn = func()

print(type(cdn))

-- #####################

agent1 = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.65 Safari/535.11"
agent2 = "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110421 Red Hat/3.6.17-1.el6_0 Firefox/3.6"
agent3 = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322)"
agent4 = "xzczxc"


if string.find(agent4,"Windows NT 5.2") then
   os = "windows server 2003"
   int(os)
else
   os = "unkown"
   print(os)
end 

if string.find(agent2,".*Firefox/([.0-9]+)") then
    print("zxc")
else
   print("no find")
end


if string.find(agent3,".*MSIE%s+([.0-9]+)") then
    _,_,ver = string.find(agent3,".*MSIE%s+([.0-9]+)") 
   print(ver)
else
   print("no find")
end


if string.find(agent1,".*Chrome/([.0-9]+)") then
    _,_,ver = string.find(agent1,".*Chrome/([.0-9]+)")
   print(ver)
else
   print("no find")
end

-- ###########################

str = "1"
num = tonumber(str)


--[[
if tonumber(str) >= 1 then
   print("suc")
end
--]]

if tonumber(str) and tonumber(str) >= 1 then
   print("suc")
end 

-- ###########################
flag = "L8"

if string.sub(flag,1,1) == "L" then
   print("yes")
end

-- ###########################


t1 = {name="terry",age=18}

print("cjson : ",cjson.encode(t1))

-- #############################

if not t1["jack"] then
   print("xiahah")
end

-- ############################

str = "HHHyuJI_jkhl_10"

a,b,vid,pid,flag = string.find(str,"(.*)_(.*)_(.*)")

print(flag)


-- ###########################
--

t1 = {}

t1[0] =  "0"
t1[3] = "3"
t1[5] = "5"
t1[2] = "2"
t1[6] = "6"
t1[4] = "4"

for k,v in pairs(t1) do
    print(k,v)
end
print(t1[02])

--print(cjson.encode(t1))

-- #########################
print(0%2)

-- ########################

test = {"0","2","3",
        "4","5" }

print(test[5])


