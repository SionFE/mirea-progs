function markside(r, b)
    while !isborder(r, b)
        move!(r, b)
        if ismarker(r)
            return 1
            break
        end
        putmarker!(r)
    end
    return 0
end
function perimeter(r)
    steps=0
    while !isborder(r, Sud)
        steps+=1
        move!(r, Sud)
    end
    putmarker!(r)
    for i=3:7
        if markside(r, HorizonSide(i%4))==1
            break
        end
    end
    for i=1:steps
        move!(r, Nord)
    end
end