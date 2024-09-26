function checkFileExists(path, sha256sum)
    file_exists = isfile(path)
    if file_exists
        file_sha256 = open(path) do io
            io |> sha256 |> bytes2hex
        end
        if file_sha256 == sha256sum
            return true
        else
            return false
        end
    else
        return false
    end
end

function flow(path::Expr, expr::Expr)
    return quote
       filePath = $(esc(path.args[2]))
       hash_file = filePath * ".hash"
       # Check if hash file exists
       flag = true
       if isfile(hash_file)
           # Read the saved hash
           saved_hash = read(hash_file, String)

           # Check if the file exists and hash matches
           if $checkFileExists(filePath, saved_hash)
               flag = false
           end
       end

       if flag
           $(esc(expr))

           # Compute new hash and save it
           new_hash = open(filePath) do io
               io |> $sha256 |> $bytes2hex
           end
           open(hash_file, "w") do io
               write(io, new_hash)
           end
       end
    end
end

"""
    @flow path="path/to/file" expr

A macro that checks if the file in the `path` exists and if it didn't change and only runs the `expr` if needed. After the first run, create a file with the same name as `path` with the .hash suffix, and writes the sha256 sum hash.

# Example

```jldoctest
julia> filePath, _ = mktemp();

julia> @flow path=filePath begin
           println("This should only show once")
           write(filePath, "some random text")
       end
This should only show once
64

julia> @flow path=filePath begin
           println("This should only show once")
           write(filePath, "some random text")
       end
```
"""
macro flow(path::Expr, expr::Expr)
    if path.args[1] != :path
        error("Missing path keyword argument")
    end

    return flow(path, expr)
end
