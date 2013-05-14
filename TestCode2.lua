                     local redis = require "resty.redis"
                     local json = require "json"
                     local cjson = require "cjson"

                     local redata = redis:new()
                     redata:set_timeout(1000)
                     local ok,err = redata:connect("127.0.0.1",6379)
                     if not ok then
                        print("error1")
                        return
                     end


                     local ok,err = redata:hkeys("loadhash")
                     print(ok)

