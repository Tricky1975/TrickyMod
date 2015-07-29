--[[
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 2.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is created by Nick Gammon, freely distributed.
 *
 * The Initial Developer of the Original Code is
 * Nick Gammon.
 * Portions created by the Initial Developer are Copyright (C) 2012
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 * Jeroen "Tricky" Broks (altering for GALE)
 *
 * ***** END LICENSE BLOCK ***** */



Version: 13.12.26

]]

--[[

  The file below was originally written by Nick Gammon. 
  All I did was completely restyling it so that it was fit to use with the GALE project (and fixing some bugs that were in it).
  To the original project no true license was given, and therefore the MPL license (as listed above) generally goes for my own adeptions to this code, and not the original code.
 
  For the original code please visit: http://www.gammon.com.au/forum/bbshowpost.php?bbsubject_id=4960 

]]



-- When the requested variable is nothing but a single value, we don't need no complicated serializing processes, and this function will just return a string value representing this.
function ___JBC___basicSerialize(o)
  if type(o) == "number" or type(o) == "boolean" then
    return tostring(o)
  else   -- assume it is a string
    return string.format("%q", o)
  end
end -- basicSerialize 


--
-- Lua keywords might look OK to not be quoted as keys but must be.
-- So, we make a list of them.
--

___JBC___lua_reserved_words = {}

for ___JBC___rv_k, ___JBC___v in pairs({
    "and", "break", "do", "else", "elseif", "end", "false", 
    "for", "function", "if", "in", "local", "nil", "not", "or", 
    "repeat", "return", "then", "true", "until", "while"
            }) do ___JBC___lua_reserved_words [___JBC___v] = true end

-- ----------------------------------------------------------
-- save one variable (calls itself recursively)
-- ----------------------------------------------------------
function ___JBC___save(___JBC___name, ___JBC___value, ___JBC___out, ___JBC___indent, ___JBC___saved)
  ___JBC___saved = ___JBC___saved or {}       -- initial value
  ___JBC___indent = ___JBC___indent or 0      -- start ___JBC___indenting at zero cols
  local ___JBC___iname = string.rep ("  ", ___JBC___indent) .. ___JBC___name -- indented name
  if type(___JBC___value) == "number" or 
     type(___JBC___value) == "string" or
     type(___JBC___value) == "boolean" then
    table.insert(___JBC___out, ___JBC___iname .. " = " .. ___JBC___basicSerialize(___JBC___value).."")
  elseif ___JBC___value==nil then
    table.insert(___JBC___out, ___JBC___iname .. " = nil\n");
  elseif ___JBC___value==false then
    table.insert(___JBC___out, ___JBC___iname .. " = false\n");
  elseif type(___JBC___value) == "table" then
    if ___JBC___saved[value] then    -- value already ___JBC___saved?
      table.insert (___JBC___out, ___JBC___iname .. " = " .. ___JBC___saved[value])  -- use its previous name
    else
      ___JBC___saved[___JBC___value] = ___JBC__name   -- save name for next time
      table.insert (___JBC___out, ___JBC___iname .. " = {}")   -- create a new table
      for ___JBC___k,___JBC___v in pairs(___JBC___value) do      -- save its fields
        local ___JBC___fieldname 
        if type (___JBC___k) == "string"
           and string.find (___JBC___k, "^[_%a][_%a%d]*$") 
           and not ___JBC___lua_reserved_words [___JBC___k] then
          ___JBC___fieldname = string.format("%s.%s", ___JBC___name, ___JBC___k)
        else
          ___JBC___fieldname  = string.format("%s[%s]", ___JBC___name,
                                        ___JBC___basicSerialize(___JBC___k))  
        end
        ___JBC___save(___JBC___fieldname, ___JBC___v, ___JBC___out, ___JBC___indent + 2, ___JBC___saved)
      end
    end
  else
    error("cannot save a " .. type(___JBC___value))
  end
end  -- save 

-- ----------------------------------------------------------
-- Serialize a variable or nested set of tables:
-- ----------------------------------------------------------

--[[

  Example of use:

  SetVariable ("mobs", serialize ("mobs"))  --> serialize mobs table
  loadstring (GetVariable ("mobs")) ()  --> restore mobs table 

--]]

function serialize (what, v)
  v = v or _G [what]  -- default to "what" in global namespace

  assert (type (what) == "string", 
          "Argument to serialize should be the *name* of a variable")
  --assert (v, "Variable '" .. what .. "' does not exist")

  local ___JBC___out = {}  -- output to this table
  ___JBC___save(what, v, ___JBC___out)   -- do serialization
  JBCSYSTEM.Returner(table.concat (___JBC___out, "\r\n"))
  return table.concat (___JBC___out, "\r\n")  -- turn into a string
end -- serialize

function serialize2 (what)
JBCSYSTEM.DebugLog("what = "..what)
JBCSYSTEM.DebugLog(_G[what])
___DEBUG_G()
serialize(what,nil)
end
