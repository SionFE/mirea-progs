function inttosideconverter(b)
    return HorizonSide(abs(b%4))
end
function moveback!(r, steps, side)
    for i in 1:steps
        move!(r, side)
    end
end
function reverse(side)
    return HorizonSide((Int(side)+2)%4)
end
function movetillwall!(r,s)
    steps=0
    while !isborder(r,s)
        steps+=1
        move!(r,s)
    end
    return steps
end
function checkforrectangle(r, side)
    countsteps=0
    movedir=HorizonSide((Int(side)+1)%4)
    while !isborder(r,movedir)
        move!(r,movedir)
        countsteps+=1
        if !isborder(r,side)
            moveback!(r, countsteps, reverse(movedir))
            return 1
        end
    end
    moveback!(r, countsteps, reverse(movedir))
    return 0
end
function marktherectangle(r,side)
    for i in Int(side)+1:Int(side)+4
        putmarker!(r)
        while isborder(r, reverse(inttosideconverter(i+1)))
            move!(r, reverse(inttosideconverter(i)))
            putmarker!(r)
        end
        move!(r, reverse(inttosideconverter(i+1)))
    end
    while !ismarker(r)
        putmarker!(r)
        move!(r, inttosideconverter(Int(side)-1))
    end
end
function findandmarktherectangle(r)
    for i in (HorizonSide(s) for s in 0:3)
        steps=movetillwall!(r,i)
        if checkforrectangle(r,i)==1
            marktherectangle(r,i)
            moveback!(r, steps, reverse(i))
            break
        end
        moveback!(r, steps, reverse(i))
    end
end