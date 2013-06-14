local cjson = require "cjson"


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

a=89

b=90

print(math.abs(a-b))
print(math.abs(b-a)) 

alltimepoint = {}
for i=0,17,1 do
    alltimepoint[i] = 0
end 


print(cjson.encode(alltimepoint))

periodlist = {{12,34},{45,89},{78,45}}

print(cjson.encode(periodlist))

                        tmplist = {}
                        for i,v in ipairs(periodlist) do
                            if tonumber(v[1]) > tonumber(v[2]) then
                               tmplist = {tonumber(v[1])-10,tonumber(v[2])}

                               table.remove(periodlist,i)   
                               table.insert(periodlist,tmplist)
                            end
                        end

print(cjson.encode(periodlist))





for i = 0,37,2 do
    print(i)
end

-- #######################

function htgetn(hashtable)
   local n = 0
   for _,v in pairs(hashtable) do
        n = n + 1
   end
   return n
end

xiha = {}

print("xiha len is:")
print(htgetn(xiha))


tmplist = {{0,2,2},{2,4,2},{4,6,3}}

function MergerPlaySeg(oldlist)
   newlist = {}
   tmplist = {}
   
   for k1,k2,v in ipairs(oldlist) do
       print("cx")       
   end
            
end













