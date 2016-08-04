--[[
        Serializer.lua
	(c) 2012, 2015, 2016 Jeroen Petrus Broks.
	
	This Source Code Form is subject to the terms of the 
	Mozilla Public License, v. 2.0. If a copy of the MPL was not 
	distributed with this file, You can obtain one at 
	http://mozilla.org/MPL/2.0/.
        Version: 16.03.13
]]

--[[

History:
13.12.26 - Original version based on lua code by Nick Gammon
15.08.15 - Nick Gammon's code entirely replaced by my own new code, creating (in my humble opinion) much cleaner serialized code.
         - Placed a replacer of os.exit for Sys.Bye making sure exits are always done the "clean" way, though I am thinking of a total crashout mode
         - The contents of the "strings" library have been moved in here.
         - len returning a table in stead of the table length bug has been fixed
         - mid working with one letter too many bug has been fixed
         - Each libary has been put in here as well   
16.02.25 - Len with 'nil' value will not lead to crashes any more               
16.03.13 - "then" expected? I wonder how the script worked before if this was an issue all the time? Not possible, but yet it suddenly happened. I believe in ghosts now. Anyway, it's fixed!
16.08.04 - Optimized Lua script for serializing as it was SLOOOOW!!!

]]

-- replace os.exit
os.exit = Sys.Bye

-- Boolean features
boolyn = { [true] = "yes", [false] =  "no" }
boolbt = { [true] =     1, [false] =     0 }
boolon = { [true] =  "on", [false] = "off" }


function nonil(n)
if n==nil then return false else return n end
end

-- svalue 

svaltypes = {

   ['string']   = function(a) return a end,
   ['number']   = function(a) return a end,
   ['table']    = function(a) return serialize('<table>',a) end,
   ['function'] = function(a) return "<function>" end,
   ['nil']      = function(a) return "<nil>" end,
   ['unknown']  = function(a) return "<unknown type: "..type(a)..">" end,
   ['boolean']  = function(a) if a then return "true" else return "false" end end
   }

function sval(a)
local f = svaltypes[type(a)] or svaltypes.unknown
return f(a)
end



-- Table features -- 
function each(a) -- BLD: Can be used if you only need the values in a nummeric indexed tabled. (as ipairs will always return the indexes as well, regardeless if you need them or not)
local i=0
if type(a)~="table" then
   Console.Write("Each received a "..type(a).."!",255,0,0)
   return nil
   end
return function()
    i=i+1
    if a[i] then return a[i] end
    end
end

function ieach(a) -- BLD: Same as each, but not in reversed order
local i=#a+1
if type(a)~="table" then
   Console.Write("IEach received a "..type(a).."!",255,0,0)
   return nil
   end
return function()
    i=i-1
    if a[i] then return a[i] end
    end
end

--[[

    This function is written by Michal Kottman.
    http://stackoverflow.com/questions/15706270/sort-a-table-in-lua

]]

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


-- String features --
upper = string.upper
lower = string.lower
chr = string.char
printf = string.format
replace = string.gsub
rep = string.rep
substr = string.sub


function cprintf(a,b)
print(printf(a,b))
end

function len(a)
local k,v
local ret=0
if not a then return 0 end
if type(a)=="table" then
  --for k,v in ipairs(a) do
  --    ret = ret + 1
  --    end
  return #a
  end
return string.len(a.."") -- the .."" is to make sure this is string formatted! ;)  
end

function left(s,l)
return substr(s,1,l)
end

function right(s,l)
local ln = l or 1
local st = s or "nostring"
-- return substr(st,string.len(st)-ln,string.len(st))
return substr(st,-ln,-1)
end 

function mid(s,o,l)
local ln=l or 1
local of=o or 1
local st=s or ""
return substr(st,of,(of+ln)-1)
end 


function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
-- from PiL2 20.4

function findstuff(haystack,needle) -- BLD: Returns the position on which a substring (needle) is found inside a string or (array)table (haystrack). If nothing if found it will return nil.<p>Needle must be a string if haystack is a string, if haystack is a table, needle can be any type.
local ret = nil
local i
for i=1,len(haystack) do
    if type(haystack)=='table'  and needle==haystack[i] then ret = ret or i end
    if type(haystack)=='string' and needle==mid(haystack,i,len(needle)) then ret = ret or i end
    -- rint("finding needle: "..needle) if ret then print("found at: "..ret) end print("= Checking: "..i.. " >> "..mid(haystack,i,len(needle)))
    end
return ret    
end

function safestring(s)
local allowed = "qwertyuiopasdfghjklzxcvbnmmQWERTYUIOPASDFGHJKLZXCVBNM 12345678890-_=+!@#$%^&*()[]{};:|,.<>/?"
local i
local safe = true
local alt = ""
assert ( type(s)=='string' , "safestring expects a string not a "..type(s) )
for i=1,len(s) do
    safe = safe and (findstuff(allowed,mid(s,i,1))~=nil)
    alt = alt .."\\"..string.byte(mid(s,i,1),1)
    end
-- print("DEBUG: Testing string"); if safe then print("The string "..s.." was safe") else print("The string "..s.." was not safe and was reformed to: "..alt) end    
local ret = { [true] = s, [false]=alt }
-- print("returning "..ret[safe])
return ret[safe]     
end 


-- constructed with the Str object in GALE.
-- If the module is not used in the GALE calling engine, this part should be ignored :)
if Str then
   function prefixed(s,p) return Str.Prefixed(s,p)==1 end 
   function suffixed(s,p) return Str.Suffixed(s,p)==1 end    
   end

-- Error support
function GALE_Assert(booleanexpression,error,exdata,nocrash) -- BLD: Check an expression and crashout if the expression is seen as 'nil' or 'false'. If 'nocrash' is set to 'true' the system will not crash out, but cast a warning on the debug console in stead.
if booleanexpression then return end
({[false]=function() Sys.Error(error or "Undefined Error",exdata) end,
  [true]=function() Console.Write("WARNING!",255,180,0) Console.Write(error or "Undefined error",255,180,0)
                    Console.Write(exdata,255,180,0) end})[nocrash~=nil and nocrash~=false]()
end


-- Serializing
function TRUE_SERIALIZE(vname,vvalue,tabs,noenter)
local ret = ""
__serialize_work = __serialize_work or {
                ["nil"]        = function() return "nil" end,
                ["number"]     = function() return vvalue end,
                ["function"]   = function() Sys.Error("Cannot serialize functions") return "ERROR" end,
                ["string"]     = function() return "\""..safestring(vvalue).."\"" end,
                ["boolean"]    = function() return ({[true]="true",[false]="false"})[vvalue] end,
                ["table"]      = function()
                                 local titype
                                 local tindex = {
                                                   ["number"]     = function(v) return v end,
                                                   ["boolean"]    = function(v) return ({[true]="true",[false]="false"})[v] end,
                                                   ["string"]     = function(v) return "\""..safestring(v).."\"" end
                                 }
                                 local wrongindex = function() Sys.Error("Type "..titype.." can not be used as a table in serializing") end
                                 local ret = "{"
                                 local k,v
                                 local result
                                 local notfirst
                                 for k,v in pairs(vvalue) do
                                     if notfirst then ret = ret .. ",\n" else notfirst=true ret = ret .."\n" end
                                     titype = type(k)
                                     result = (tindex[titype] or wrongindex)(k)
                                     -- print(titype.."/"..k)
                                     ret = ret .. TRUE_SERIALIZE("["..result.."]",v,(tabs or 0)+1,true)                                      
                                     end
                                 --if notfirst then    
                                 --  ret = ret .."\n"    
                                 --  for i=1,tabs or 0 do ret = ret .."     " end   
                                 --  for i=1,len(vname.." = ") do ret = ret .. " " end
                                 --  end 
                                 ret = ret .. "}"  
                                 return ret  
                                 end 
                                   
             }    
--local work = __serialize_work                      
local letsgo = __serialize_work[type(vvalue)] or function() Sys.Error("Unknown type. Cannot serialize","Variable,"..vname..";Type Value,"..type(vvalue)) end
local i
for i=1,tabs or 0 do ret = ret .."       " end
ret = ret .. vname .." = "..letsgo() 
if not noenter then ret = ret .."\n" end
return ret
end


function serialize(vname,variableitself)
local ret = ""
local v = variableitself or _G[vname]
GALE_Assert(type(vname)=='string',"First variable must be the name to return in the serializer string")
ret = TRUE_SERIALIZE(vname,v)
JBCSYSTEM.Returner(ret)
return ret
end

