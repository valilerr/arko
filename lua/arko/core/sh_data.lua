arko.data = {}

function arko.data.init()
    if SERVER then
        file.CreateDir('arko')
        file.CreateDir('arko/sv')
        file.Write('arko/sv/info.json', util.TableToJSON({version = arko.version, cfg = arko.cfg}))
    else
        file.CreateDir('arko')
        file.CreateDir('arko/cl')
    end
end

function arko.data.write(dir, fileName, content, cl_or_sv)
    if cl_or_sv then
        file.CreateDir('arko/' .. dir)
        file.Write('arko/' .. dir .. '/' .. fileName, content)
    end
end

function arko.data.append(dir, fileName, content, cl_or_sv)
    if cl_or_sv then
        file.CreateDir('arko/' .. dir)
        file.Append('arko/' .. dir .. '/' .. fileName, content)
    end
end

function arko.data.get(path, cl_or_sv)
    if cl_or_sv then
        return file.Read('arko/' .. path, 'DATA')
    end
end

function arko.data.delete(path, cl_or_sv)
    if cl_or_sv then
        file.Delete('arko/' .. path, 'DATA')
    end
end

arko.data.init()