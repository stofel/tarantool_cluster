#!./1.9/tarantool
--#!/usr/bin/env tarantool


local fio = require 'fio'
local log = require 'log'
local errno = require 'errno'
local yaml = require 'yaml'
local console = require 'console'
local socket = require 'socket'
local ffi = require 'ffi'
local os = require 'os'
local fiber = require 'fiber'
local digest = require 'digest'
local urilib = require 'uri'


ffi.cdef[[ int kill(int pid, int sig); ]]

--start_script_path = fio.pathjoin(instance_dir, start_script_name)

local function directory_exists( sPath )
   local ok, err, code = os.rename(sPath, sPath)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end


local function getData(instance)
    local t = dofile('./' .. instance .. '/conf.lua')
    return t
end



function start(instance)
    log.info("Starting " .. instance .." instance...")
    local local_conf = getData(instance)
    local conf = {
      pid_file     = './' .. instance .. '/tarantool.pid',
      --logger       = './' .. instance .. '/tarantool.log',
      log          = './' .. instance .. '/tarantool.log',
      wal_dir      = './' .. instance,
      --snap_dir     = './' .. instance,
      memtx_dir    = './' .. instance,
      vinyl_dir    = './' .. instance,
      background   = true
    }
    

    for k,v in pairs(local_conf.box) do conf[k] = v  end
    box.cfg(conf)


    -- Start console
    if local_conf.console_url then
      local console = require('console')
      console.listen(local_conf.console_url)
    end


    local success, data = pcall(dofile, './funs.lua')
    -- if load fails - show last 10 lines of the log file
    if not success then
        print('Start failed: ' .. data)
        if fio.stat(box.cfg.logger) then
            os.execute('tail -n 10 ' .. box.cfg.logger)
        end
    else
      success, data = pcall(dofile, './' .. instance .. '/start.lua')
      -- if load fails - show last 10 lines of the log file
      if not success then
        print('Start failed: ' .. data)
        if fio.stat(box.cfg.logger) then
            os.execute('tail -n 10 ' .. box.cfg.logger)
        end
      end
    end
end


function stop(instance)
    log.info("Stopping " .. instance .." instance...")
    local pid_file = './' .. instance .. '/tarantool.pid'
    if fio.stat(pid_file) == nil then
        log.error("Process is not running (pid: %s)", pid_file)
        return 0
    end

    local f = fio.open(pid_file, 'O_RDONLY')
    if f == nil then
        log.error("Can't read pid file %s: %s", pid_file, errno.strerror())
        return -1
    end

    local str = f:read(64)
    f:close()

    local pid = tonumber(str)

    if pid == nil or pid <= 0 then
        log.error("Broken pid file %s", pid_file)
        fio.unlink(pid_file)
        return -1
    end

    if ffi.C.kill(pid, 15) < 0 then
        log.error("Can't kill process %d: %s", pid, errno.strerror())
        fio.unlink(pid_file)
        return -1
    end
    return 0
end


function init(instance)
    log.info("Init " .. instance .." instance...")

    if directory_exists(instance) then
      log.info("Node already exists")
      return -1
    else
      os.execute('cp -R template ' .. instance)
      log.info("Init " .. instance .." complete. Please edit " .. instance .. "/conf.lua")
    end
    return 0
end




local available_commands = {
    'start',
    'stop',
    'restart',
    'init'
}


local function usage()
    print("Usage: ./tarantoolctl.lua", table.concat(available_commands, '|'), 'instance')
    os.exit(1)
end


local function check_cmd(cmd)
    for _, vcmd in pairs(available_commands) do
        if cmd == vcmd then
            return cmd
        end
    end
    usage()
end


local cmd = check_cmd(arg[1])

if cmd == 'start' then
    start(arg[2])

elseif cmd == 'stop' then
    os.exit(stop(arg[2]))

elseif cmd == 'restart' then
    stop(arg[2])
    fiber.sleep(1)
    start(arg[2])

elseif cmd == 'init' then
    init(arg[2])


end

