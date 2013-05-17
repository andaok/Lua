local cjson = require "cjson"


for i=2,4,1 do
    print(i)
end

tt = {2,7,9}

for i,v in ipairs(tt) do

    print(i,v)
end


                     function htgetn(hashtable)
                        local n = 0
                        for _,v in pairs(hashtable) do
                            n = n + 1
                        end
                        return n
                     end


print(htgetn(tt))

print("------")

SegmentFlagDict = {1,1,1,1,6,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0}

table.remove(SegmentFlagDict,4)

print(SegmentFlagDict[5])




                        for i,v in ipairs(SegmentFlagDict) do
                            if tonumber(v) == 0 then
                               table.remove(SegmentFlagDict,i)
                               print(cjson.encode(SegmentFlagDict))
                            end
                        end

print(cjson.encode(SegmentFlagDict))

print(os.date())
