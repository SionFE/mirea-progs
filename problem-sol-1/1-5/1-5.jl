function movetillwall(r,s)
    steps=0
    while !isborder(r,s)
        steps+=1
        move!(r,s)
    end
    return steps
end


function movetocorner(r,s)
    path=Int[]
    dir1=HorizonSide(s%4)
    dir2=HorizonSide((s+1)%4)
    while !isborder(r,dir1) || !isborder(r,dir2)
        push!(path,movetillwall(r,dir1))
        push!(path,movetillwall(r,dir2))
    end
    return path
end


function getback(r,path,s)
    l=0
    for i in path
        l+=1
        for i2=1:i
            move!(r,HorizonSide((s+(l%2))%4))
        end
    end
end


function markcorners(r)
    for i=0:3
        path=movetocorner(r,i)
        putmarker!(r)
        getback(r,reverse(path),(i+2)%4)
    end
end