
                     local log_dict = ngx.shared.log_dict
                     local redis = require "resty.redis"
                     local json = require "json"
                     local cjson = require "cjson"

                     local red = redis:new()
                     red:set_timeout(1000)
                     local ok,err = red:connect("127.0.0.1",6379)
                     if not ok then
                        succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail connect to local redis , Error info "..err)
                        return
                     end

                     -- Every player data,pending list and end list store in "redata" redis server
                     local redata = redis:new()
                     redata:set_timeout(1000)
                     local ok,err = redata:connect("127.0.0.1",6379)
                     if not ok then
                        succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail connect to remote redis , Error info "..err)
                        return
                     end
 
                     -- Public functions

                     -- Calculate the number of elements for table
                     function htgetn(hashtable)
                        local n = 0
                        for _,v in pairs(hashtable) do
                            n = n + 1
                        end
                        return n
                     end
                     
                     -- To parse user os and browser information from agent
                     function ParseOSandBrowser(agent)
                        -- OS
                        if string.find(agent,"Linux") then
                           os = "linux"
                        elseif string.find(agent,"Windows NT 5.0") or string.find(agent,"Windows 2000") then
                           os = "windows 2000"
                        elseif string.find(agent,"Windows NT 5.1") or string.find(agent,"Windows XP") then
                           os = "windows xp"
                        elseif string.find(agent,"Windows NT 5.2") then
                           os = "windows server 2003"
                        elseif string.find(agent,"Windows NT 6.0") then
                           os = "windows vista"
                        elseif string.find(agent,"Windows NT 6.1") then
                           os = "windows 7"
                        elseif string.find(agent,"Windows NT 6.2") then
                           os = "windows 8"
                        elseif string.find(agent,"Windows ME") then
                           os = "windows me"
                        elseif string.find(agent,"OpenBSD") then
                           os = "openbsd"
                        elseif string.find(agent,"SunOS") then
                           os = "sunos"
                        elseif string.find(agent,"Mac_PowerPC") or string.find(agent,"Macintosh") then
                           os = "macos"
                        else
                           os = "Unknown"
                        end

                        -- Browser
                        if string.find(agent,".*Firefox/([.0-9]+)") then
                           _,_,ver = string.find(agent,".*Firefox/([.0-9]+)")
                           browser = "firefox "..ver
                        elseif string.find(agent,".*MSIE%s+([.0-9]+)") then
                           _,_,ver = string.find(agent,".*MSIE%s+([.0-9]+)")
                           browser = "msie "..ver
                        elseif string.find(agent,".*Chrome/([.0-9]+)") then
                           _,_,ver = string.find(agent,".*Chrome/([.0-9]+)")
                           browser = "chrome "..ver
                        else
                           browser = "Unknown"
                        end

                        return os,browser
                     end

                     
                     -- Handle player load failure
                     function PlayerLoadFail(key,value)
                        local remoteip = ngx.var.remote_addr
                        local useragent = ngx.var.http_user_agent
                        local time = os.time() 
                        local os,browser = ParseOSandBrowser(useragent)

                        value["os"] = os
                        value["browser"] = browser
                        value["ip"] = remoteip
                        value["loadtime"] = time

                        jsonvalue = cjson.encode(value)
                                           
                        local ok,err = red:set(key,jsonvalue)
                        if not ok then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail set to redis , Error info "..err)
                           return
                        end
                     end

                     -- Handle check user remaining flow
                     function CheckFlow(key,value)
                        local remoteip = ngx.var.remote_addr
                        local useragent = ngx.var.http_user_agent
                        local time = os.time()
                        local os,browser = ParseOSandBrowser(useragent)

                        value["os"] = os
                        value["browser"] = browser
                        value["ip"] = remoteip
                        value["loadtime"] = time

                        -- Record client area information
                        if ngx.var.geoip_city_country_name then
                           value["country"] = ngx.var.geoip_city_country_name
                           value["region"] = ngx.var.geoip_region
                           value["city"] = ngx.var.geoip_city
                        else
                           value["country"] = "local"
                           value["region"] = "local"
                           value["city"] = "local"
                        end
                        
                        jsonvalue = cjson.encode(value)

                        local ok,err = red:set(key,jsonvalue)
                        if not ok then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail set to redis , Error info "..err)
                           return
                        end

                        -- Check flow and return result to client
                        -- Write vid_pid to loadlist
                         
                     end
                   
                     -- Handle play video failure in first play
                     function PlayVideoFail(key,value)
                        local time = os.time()
                    
                        value["starttime"] = time
                        jsonvalue = cjson.encode(value)
 
                        local ok,err = red:set(key,jsonvalue)
                        if not ok then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail set to redis , Error info "..err)
                           return
                        end
                     end

                     -- Handle play video success
                     function PlayVideoSuc(key,value)
                        local time = os.time()

                        value["starttime"] = time
                        value["flag"] = "start"
                        jsonvalue = cjson.encode(value)

                        local ok,err = red:set(key,jsonvalue)
                        if not ok then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail set to redis , Error info "..err)
                           return
                        end
                      
                        -- Write vid_pid to pendinglist
                     end
                     
                     -- ######################################################
                     -- Handle video play window close
                     function PlayWindowClose(vid,pid,Cvalue)
                        -- Obtain "loadtime,ip,os,browser,country,region,city" from "vid_pid_Y"
                        -- Obtain "starttime" from "vid_pid_0"
                        --
                        red:init_pipeline()
                        red:get(vid.."_"..pid.."_".."Y")
                        red:get(vid.."_"..pid.."_".."0")
                        local results,err = red:commit_pipeline()
                        if not results then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fun -- PlayWindowClose -- 1 -- Fail get from redis pipeline , Error info "..err)
                           return
                        end                        
                        
                        -- "S" will be store in redis(redata) by keyname "vid_pid_S"
                        local S = cjson.decode(results[1])
                        S["starttime"] = cjson.decode(results[2])["starttime"]
                        
                        -- #######################
                        KeyNameList = {}
                        -- Obtain all "vid_pid_N" data from redis(red),N=[0-10000]
                        local res,err = red:keys(vid.."_"..pid.."_".."[0-9]*")
                        if not res then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fun -- PlayWindowClose -- 2 -- Fail keys from redis , Error info "..err)
                           return
                        end

                        for i,key in ipairs(res) do
                            local _,_,_,_,flag = string.find(key,"(.*)_(.*)_(.*)")
                            if tonumber(flag) then
                               KeyNameList[tonumber(flag)] = key
                            end 
                        end

                        -- Obtain all "vid_pid_LN" data from redis(red),N=[1-10000]
                        local res,err = red:keys(vid.."_"..pid.."_".."L[0-9]*")
                        if not res then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fun -- PlayWindowClose -- 3 -- Fail keys from redis , Error info "..err)
                           return
                        end

                        for i,key in ipairs(res) do
                            local _,_,_,_,flag = string.find(key,"(.*)_(.*)_L(.*)")
                            if tonumber(flag) then
                               KeyNameList[tonumber(flag)] = key
                            end
                        end
 
                        --ngx.print("key list : ",cjson.encode(KeyNameList))
                        
                        red:init_pipeline()
                        for i,key in pairs(KeyNameList) do
                            red:get(key)
                        end                        
                        local results,err = red:commit_pipeline()
                        if not results then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fun -- PlayWindowClose -- 3 -- Fail get from redis pipeline , Error info "..err)
                           return
                        end
                        -- ########################
                        
                        -- ########################
                        -- "pauselist" store pause playtime,format is "{10,19,67,......}"
                        local pauselist = {}
                        -- "endsum" store number of play complete sum
                        local endsum = 0

                        -- "periodlist" store play segment data,format is {{PlayTime,OldTime},...},e.g {{0,13},{15,25},...}
                        local periodlist = {}
                        -- "lidlist" store video flow switch data,format is {{StartPlayTime,FlowLevel,EndPlayTime},...},e.g { {0,2,10},{11,3,18},...}
                        local lidlist = {}
                        
                        local dtmplist = {}  
                        local ftmplist = {}
                        local flowlevel = 0 
                        
                        
                        -- The judgment of received data(vid_pid_N) is what action trigger
                        -- "start" : the expressed start(and restart) play video
                        -- "drag"  : the expressed Click progress bar trigger
                        -- "pause" : the expressed Click pause button trigger
                        -- "end"   : the expressed video auto play complete
                        -- "switch": the expressed flow level switch trigger

                        for key,value in ipairs(results) do
                            ngx.say(key,value)
                            tvalue = cjson.decode(value)
                            
                            --Post key format is vid_pid_N(0-10000),action is "start" 
                            if tvalue["flag"] == "start" then
                               flowlevel = tonumber(tvalue["lid"])
                               ftmplist = {tvalue["playtime"],tvalue["lid"]} 

                               table.insert(dtmplist,tvalue["playtime"])
                            end
                          
                            --Post key format is vid_pid_N(1-10000),action is "drag"
                            if tvalue["oldtime"] then
                               table.insert(ftmplist,tvalue["oldtime"]) 
                               table.insert(lidlist,ftmplist)
                               ftmplist = {tvalue["playtime"],flowlevel}
                                
                               table.insert(dtmplist,tvalue["oldtime"])
                               table.insert(periodlist,dtmplist)
                               dtmplist = {tvalue["playtime"]}
                            end
                            
                            --Post key format is vid_pid_N(1-10000),action is "pause"
                            if tvalue["flag"] == "pause" then
                               table.insert(ftmplist,tvalue["playtime"])
                               table.insert(lidlist,ftmplist)
                               ftmplist = {tvalue["playtime"],flowlevel}
                               
                               table.insert(pauselist,tvalue["playtime"])
                            end

                            --Post key format is vid_pid_LN(1-10000),action is "switch"
                            if htgetn(tvalue) == 2 and tvalue["lid"] then
                               flowlevel = tonumber(tvalue["lid"])

                               table.insert(ftmplist,tvalue["playtime"])
                               table.insert(lidlist,ftmplist)
                               ftmplist = {tvalue["playtime"],flowlevel}
                            end 

                            --If post key format is vid_pid_N(1-10000),action is "end"
                            if tvalue["flag"] == "end" then
                               endsum = endsum + 1

                               table.insert(ftmplist,tvalue["playtime"])
                               table.insert(lidlist,ftmplist)
                               ftmplist = {}
                              
                               table.insert(dtmplist,tvalue["playtime"])
                               table.insert(periodlist,dtmplist)
                               dtmplist = {}
                            end    
                        end                         

                        --If you are playing or pause,close the playback window
                        if htgetn(dtmplist) == 1 then
                           table.insert(dtmplist,Cvalue["playtime"])
                           table.insert(periodlist,dtmplist)
                           dtmplist = {}
                        end
                        --If you are playing,close the playback window
                        if htgetn(ftmplist) == 2 then
                           table.insert(ftmplist,Cvalue["playtime"])
                           table.insert(lidlist,ftmplist)
                           ftmplist = {}
                        end
                        
                        ngx.say("periodlist is : ",cjson.encode(periodlist))
                        ngx.say("lidlist is : ",cjson.encode(lidlist))
                        ngx.say("pauselist is : ",cjson.encode(pauselist))
                        ngx.say("endlist is : ",endsum)

                        -- ######################
                        
                        -- ######################
                        -- Obtain video meta information from redata , e.g Duration, avg bitrate every flow level.
                        -- tmp data for debug
                        flbit = {332,446,722,1782} 
                        duration = 68                        
                        -- ######################

                        --#######################
                        --
                        --#######################
                       
                        -- If handle success,move vid_pid to endlist from pendinglist

                     end
                     -- ############################################################

                     -- Handle receive play information every 10 seconds
                     function RecPlayInfo(key,value)
                        jsonvalue = cjson.encode(value)

                        local ok,err = red:set(key,jsonvalue)
                        if not ok then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail set to redis , Error info "..err)
                           return
                        end
                     end

                     -- Handle video pause,drag,end
                     function VPauseDragEnd(key,value)

                        if value["lid"] then
                           value["flag"] = "start"
                        end                        

                        jsonvalue = cjson.encode(value)

                        local ok,err = red:set(key,jsonvalue)
                        if not ok then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail set to redis , Error info "..err)
                           return
                        end
                     end                     

                     -- Handle video stream switch
                     function VStreamSwitch(key,value)
                        jsonvalue = cjson.encode(value)

                        local ok,err = red:set(key,jsonvalue)
                        if not ok then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail set to redis , Error info "..err)
                           return
                        end
                     end

                     -- Handle video play error
                     function VideoPlayError(key,value)
                        jsonvalue = cjson.encode(value)

                        local ok,err = red:set(key,jsonvalue)
                        if not ok then
                           succ, err, forcible = log_dict:set(os.date("%x/%X"),"Fail set to redis , Error info "..err)
                           return
                        end
                     end

                     -- Main                     

                     ngx.req.read_body()
                     local args = ngx.req.get_post_args()

                     if htgetn(args) == 2 then

                          for name , value in pairs(args) do
                              if name ~= "key" and name ~= "value" then
                                 succ, err , forcible = log_dict:set(os.date("%x/%X"),"The post parameter name "..name.." is incorrect")
                                 return 
                              end
                          end
                        
                          a,b,vid,pid,flag = string.find(args["key"],"(.*)_(.*)_(.*)")

                          if string.len(vid) == 7 and string.len(pid) == 4 then
                                                         
                             UserId = string.sub(vid,1,4)
                             FileId = string.sub(vid,5,-1)
                   
                             lua = "return "..args["value"]
                             local func = loadstring(lua)
                             tablevalue = func()       
  
                             -- Do different according to the different flags 
                             -- Load player failure
                             if flag == "X" then
                                PlayerLoadFail(args["key"],tablevalue)
                             end
                             
                             -- Check user flow
                             if flag == "Y" then
                                CheckFlow(args["key"],tablevalue)
                             end

                             -- Play video failure in play start
                             if flag == "X0" then
                                PlayVideoFail(args["key"],tablevalue)
                             end

                             -- Play video success
                             if flag == "0" then
                                PlayVideoSuc(args["key"],tablevalue)
                             end
                          
                             -- Receive play information every 10 seconds
                             if flag == "P" then
                                RecPlayInfo(args["key"],tablevalue)
                             end

                             -- Video play window close
                             if flag == "C" then
                                PlayWindowClose(vid,pid,tablevalue)
                             end

                             -- Video pause,drag and end 
                             if tonumber(flag) and tonumber(flag) >= 1 then
                                VPauseDragEnd(args["key"],tablevalue)
                             end

                             -- Video stream switch
                             if string.sub(flag,1,1) == "L" then
                                VStreamSwitch(args["key"],tablevalue)
                             end

                             -- Video play error during play
                             if string.sub(flag,1,1) == "X" and string.len(flag) > 1 then
                                PlayVideoError(args["key"],tablevalue) 
                             end
                 
                          else
                             succ, err, forcible = log_dict:set(os.date("%x/%X"),args["key"].." data format is incorrect")
                             return
                          end                        
                           
                     else
                          succ, err, forcible = log_dict:set(os.date("%x/%X"),"the number of parameters be 2,but it is "..htgetn(args))
                          return
                     end

                                          
