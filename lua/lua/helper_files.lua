module("helper_files", package.seeall)

require("pl")
path = require("pl.path")
local tFlasherHelper = require 'flasher_helper'

function printf(...) print(string.format(...)) end


-- Checking is enabled by default.
fEnableHelperFileChecks = true

-- When the module is loaded:
-- If the environment variable CLI_FL_DISABLE_HELPER_FILE_CHECK
-- is set to any value, disable the checks 
strEnvVar = "CLI_FL_DISABLE_HELPER_FILE_CHECK"
local strEnvEnable=os.getenv(strEnvVar)
if strEnvEnable == nil then 
    -- printf("Environment variable %s is not set - enabling automatic helper file checks", strEnvVar)
    fEnableHelperFileChecks = true
else 
    -- printf("Environment variable %s is set - disabling automatic helper file checks", strEnvVar)
    fEnableHelperFileChecks = false
end

-- Disable the checks
function disableHelperFileChecks()
    -- print("Disabling automatic helper file checks")
    fEnableHelperFileChecks = false
end

-- Enable the checks
function enableHelperFileChecks()
    -- print("Enabling automatic helper file checks")
    fEnableHelperFileChecks = true
end

function getStatusString()
    local strStatus
    if fEnableHelperFileChecks then 
        strStatus = "Automatic helper file checks are enabled."
    else 
        strStatus = "Automatic helper file checks are disabled."
    end
    
    if strEnvEnable == nil then 
        strStatus = strStatus .. string.format(" Environment variable %s is not set.", strEnvVar)
    else 
        strStatus = strStatus .. string.format(" Environment variable %s is set.", strEnvVar)
    end 
    
    return strStatus
end

-- ==========================================================================
-- The list of known helper files.
-- The key is a short name for the helper. It is passed by the caller.
-- filename is the actual file name of the helper.
-- version is the expected version string.byte
-- version_offset is the offset of the version string inside the file.
-- If it is not specified, the entire file is searched for the
-- version string. 

atHelperFileVersions = {
    {
        key = "bootswitch",
        filename = "bootswitch.bin",
        version = "GITV1.0.2-0-gec97ccacc78d",
        version_offset = 0x4bc
    },

    {
        key = "return_exec",
        filename = "return_exec.bin",
        version = "Ver:GITV1.0.3-0-ge6ba63142ffe:reV",
        version_offset = 0x408
    },
    
    {
        key = "read_sip_m2m",
        filename = "read_sip_M2M.bin",
        version = "Ver:GITv1.0.0-dev4-0-ga66fb60ea736:reV",
        version_offset = 0x102c
    },
    
    {
        key = "set_kek",
        filename = "set_kek.bin",
        version = "Ver:GITv1.0.0-dev2-0-g0389874dec34:reV",
        version_offset = 0x9e8
    },
    
    {   -- This is verify_sig_intram from the build
        key = "verify_sig",  
        filename = "verify_sig.bin",
        version = "Ver:GITv1.0.0-dev2-0-g140a678c784b:reV",
        version_offset = 0x910
    },

    {   -- Todo: Turn this into a template to insert version automatically.
        key = "flasher_netx90_hboot",
        filename = "flasher_netx90_hboot.bin",
        version = "GITv2.0.0-dev10-0",
        version_offset = 0x0410
    },

    {
        key = "start_mi",
        filename = "hboot_start_mi_netx90_com_intram.bin",
        version = "Ver:GITv2.5.4-dev6-0-gc3f4f2907cb4:reV",
        version_offset = 0x0454
    },


--        Test code - todo: remove
--    {
--        key = "start_mi__wrong_filename",
--        filename = "hboot_start_mi_netx90_com_intram__.bin",
--        version = "Ver:GITv2.5.4-dev6-0-gc3f4f2907cb4:reV",
--        version_offset = 0x0454
--    },
--    {
--        key = "start_mi__wrong_offset",
--        filename = "hboot_start_mi_netx90_com_intram.bin",
--        version = "Ver:GITv2.5.4-dev6-0-gc3f4f2907cb4:reV",
--        version_offset = 0x0458
--    },
--    {
--        key = "start_mi__wrong_version",
--        filename = "hboot_start_mi_netx90_com_intram.bin",
--        version = "Ver:GITv2.5.5-dev4-6-ga3277b9142e5+:reV",
--        version_offset = 0x0454
--    },
--    
--    {
--        key = "start_mi__no_version_offset",
--        filename = "hboot_start_mi_netx90_com_intram.bin",
--        version = "Ver:GITv2.5.4-dev6-0-gc3f4f2907cb4:reV",
--    },
--    
--    {
--        key = "start_mi__no_version_offset_wrong_version",
--        filename = "hboot_start_mi_netx90_com_intram.bin",
--        version = "Ver:GITv2.5.5-dev4-6-ga3277b9142e5+:reV",
--    }
}


-- ==========================================================================
-- Load a helper file and check its version.
-- strDir: directory where the file is located
-- strKey: short name for the binary, e.g. "start_mi"
-- fCheckversion: if true/nil, always check the version
--                if false, the version check is skipped
-- 
-- Returns:
-- a binary string of the helper file, if it was found and has the 
--    expected version.
-- nil and a message string if an error occurred, e.g.
--     - unknown key
--     - file not found 
--     - version did not match

function checkHelperFileIntern(strDir, strKey, fCheckversion)
    local strBin, strMsg 
    local tEntry 
    
    if fCheckversion == nil then 
        fCheckversion = true
    end
    
    for i, e in ipairs(atHelperFileVersions) do
        if e.key == strKey then
            tEntry = e 
            break
        end 
    end
    
    if tEntry == nil then
        strMsg = string.format("Unknown helper name: '%s'", strKey)
    else
        -- build the path
        local strPath = path.join(strDir, tEntry.filename)
        local strVersion = tEntry.version
        local iOffset = tEntry.version_offset
        printf("Loading helper file '%s' from path %s", strKey, strPath)
        
        -- read the file
        strBin, strMsg = tFlasherHelper.loadBin(strPath)
        
        -- failed to read the file 
        if strBin == nil then
            strMsg = string.format("Failed to load helper file '%s': %s",
                strKey, strMsg)
            print(strMsg)
                
        -- 
        else
            printf("Helper file '%s' loaded (%d bytes)", strKey, strBin:len())
            
            if fCheckversion == true then
                local fOk
                if iOffset ~= nil then
                    local iStartOffset = iOffset+1
                    local iEndOffset = iOffset+strVersion:len()
                    local strFileVersion = strBin:sub(iStartOffset, iEndOffset)
                    fOk = ( strFileVersion == strVersion)
                else 
                    local m = strBin:find(strVersion, 1, true)
                    fOk = (m ~= nil)
                end
                
                if fOk then
                    strMsg = nil
                    printf("Helper file '%s' has the expected version (%s) - OK", strKey, strVersion)
                else 
                    strBin = nil
                    strMsg = string.format("Helper file '%s' does not have the expected version (%s) - ERROR", strKey, strVersion)
                    print(strMsg)
                end
            end
        end
    end
    
    return strBin, strMsg
end


-- Verify multiple helper directories. 
function checkHelperFilesIntern(astrHelperDirs, astrHelperNames)
    local fAllOk = true
    local atCheckedDirs = {}
    
    for iDir = 1, table.maxn(astrHelperDirs) do
        local strDir = astrHelperDirs[iDir]
        if strDir ~= nil and atCheckedDirs[strDir] == nil then 
            print()
            printf("Checking helper files in %s", strDir)
            
            for iName, strName in ipairs(astrHelperNames) do
                print()
                local strBin, strMsg = checkHelperFileIntern(strDir, strName, true)
                if strBin == nil then 
                    fAllOk = false
                end
            end
            
            atCheckedDirs[strDir] = true
        end
    end
    
    return fAllOk
end



-- ===================================================================================

-- API

-- Get a single helper from a directory
-- Returns a string with the contents of the helper file 
-- or nil and an error message.
--
-- fCheck (optional):
-- fCheck == true (default): check the file if checks are enabled
-- fCheck == false: always skip the check
function getHelperFile(strDirectory, strHelperName, fCheck)
    if (fCheck == nil) or (fCheck == true) then 
        fCheck = fEnableHelperFileChecks
    end
    
    return checkHelperFileIntern(strDirectory, strHelperName, fCheck)
end


-- Check the specified helper files in the specified directories,
-- if the checks are enabled.
-- Returns true or false
function checkHelperFiles(astrDirectories, astrHelperNames)
    local fOk
    if fEnableHelperFileChecks then
        fOk = checkHelperFilesIntern(astrDirectories, astrHelperNames)
        print()
        if fOk == true then
            print("All of the requested helper files were found and have the correct version.")
        else 
            print("Some of the requested helper files were not found or do not have the correct version.")
        end 
        print()
        
    else
        print("Skipping helper file checks")
        fOk = true
    end

    return fOk
end

-- Check all helper files in the specified directories.
-- The checks are always performed, even if they were disabled.
-- Returns true or false
function checkAllHelperFiles(astrDirectories)
    local astrHelperNames = {}
    for i, e in ipairs(atHelperFileVersions) do
        table.insert(astrHelperNames, e.key)
    end

    local fOk = checkHelperFilesIntern(astrDirectories, astrHelperNames)
    
    print()
    if fOk == true then
        print("All helper files were found and have the correct version.")
    else 
        print("Some helper files were not found or do not have the correct version.")
    end 
    print()
    
    return fOk
end
