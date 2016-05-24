
 -- /
 --   Collect user base info 
 --   Write by wye
 --   Write in 20131209 
 --   Copyright @ 2012 - 2013  Cloudiya Tech . Inc
 -- /


 local log_dict = ngx.shared.log_dict
 local redis = require "resty.redis"
 local cjson = require "cjson"

 local red = redis:new()
 red:set_timeout(1000)
 local ok,err = red:connect("127.0.0.1",6379)
 if not ok then
    succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail connect to local redis , Error info "..err)
    return
 end

 local redata = redis:new()
 redata:set_timeout(1000)
 local ok,err = redata:connect("10.2.10.19",6379)
 if not ok then
    succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail connect to remote redis , Error info "..err)
    return
 end

-- /
-- **********************************
-- FUNCTIONS
-- ********************************** 
-- /

-- Calculate the number of elements for table
function htgetn(hashtable)
   local n = 0
   for _,v in pairs(hashtable) do
       n = n + 1
   end
   return n
end

function CollectUserInfo(value,vid,pid)
	     jsonvalue = cjson.encode(value)
	     local ok,err = redata:set(vid.."_"..pid.."_z1",jsonvalue)
	     if not ok then
	        succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fun--PlayVideoFail--Fail set to redis,Error info "..err)
	        return
	     end
	     local ok,err = redata:expire(vid.."_"..pid.."_z1",129600)     
end
 
 -- /
 -- **********************************
 -- Main Program
 -- **********************************
 -- /
 
                     
local args = ngx.req.get_uri_args()

if htgetn(args) == 4 then                    
   a,b,vid,pid,flag = string.find(args["key"],"(.*)_(.*)_(.*)")

   if string.len(vid) == 7 and string.len(pid) == 4 then
                    
      UserId = string.sub(vid,1,4)

      -- Serialize string into a table data structure
      lua = "return "..args["value"]
      local func = loadstring(lua)
      tablevalue = func()
                                                
      -- Collect user base info
      if flag == "z1" then
         CollectUserInfo(tablevalue,vid,pid)                                 
      end

   else
         succ, err, forcible = log_dict:set(os.date("%x/%X"),"Main--"..args["key"].." data format is incorrect")
         return
   end                        
       
else
      succ, err, forcible = log_dict:set(os.date("%x/%X"),"Main--the number of parameters be 2,but it is "..htgetn(args))
      return
end

 -- put redis connection to conn pool
 local ok,err = red:set_keepalive(10,100)
 if not ok then
    succ, err, forcible = log_dict:set(os.date("%x/%X"),"Main--Fail to set red keepalive,error info : "..err)
 end
 local ok,err = redata:set_keepalive(10,100)
 if not ok then
    succ, err, forcible = log_dict:set(os.date("%x/%X"),"Main--Fail to set redata keepalive,error info : "..err)
 end

 
 
