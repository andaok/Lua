local cjson = require "cjson"

t={}
t["name"]="jack"
t["age"]=30

b={"one","two","three"}

for i,v in pairs(b) do
    print(i,v)
end
