
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
