local cjson = require "cjson"

t={}
t["name"]="jack"
t["age"]=30

for i,v in ipairs(t) do
    print(i)
end
