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

function runIfChanged(path::String, codeBlock::Expr)
    # Define the hash file path
    hash_file = path * ".hash"

    # Check if hash file exists
    if isfile(hash_file)
        # Read the saved hash
        saved_hash = read(hash_file, String)

        # Check if the file exists and hash matches
        if checkFileExists(path, saved_hash)
            return
        end
    end

    runPost = quote
        # Compute new hash and save it
        new_hash = open(path) do io
            io |> sha256 |> bytes2hex
        end
        open($hash_file, "w") do io
            write(io, new_hash)
        end
    end

    fullExpr = Expr(:block, esc(codeBlock), runPost)

    fullExprWithPath = postwalk(x -> x == :path ? path : x, fullExpr)

    return fullExprWithPath
end

macro flow(expr1::Expr, expr2::Expr)
    if expr1.args[1] != :path
        error("Missing path keyword argument")
    elseif !(expr1.args[2] isa String)
        error("The path value is not a String")
    end

    path = expr1.args[2]
    return runIfChanged(path, expr2)
end
