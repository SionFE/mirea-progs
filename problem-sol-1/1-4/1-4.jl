function moveback(countNord,countEast,r)
    for i=1:countNord
        move!(r,Nord)
    end
    for i=1:countEast
        move!(r,Ost)
    end
end
function movetoside(r, s)
    count=0
    while !isborder(r,s)
        move!(r,s)
        count+=1
    end
    return count
end
function movetocorner(r)
    countSud=movetoside(r, HorizonSide(2))
    countWest=movetoside(r, HorizonSide(1))
    return countSud, countWest
end
function filltherow(r,s)
    putmarker!(r)
    for i=1:s
        move!(r,Ost)
        putmarker!(r)
    end
    while !isborder(r,West)
        move!(r,West)
    end
    if !isborder(r,Nord)
        move!(r,Nord)
        putmarker!(r)
        filltherow(r,s-1)
    end
end
function initsize(r)
    size=0
    while !isborder(r,Ost)
        size+=1
        move!(r,Ost)
        putmarker!(r)
    end
    return size
end
function fill(r)
    a,b=movetocorner(r)
    putmarker!(r)
    size=initsize(r)
    movetocorner(r)
    move!(r,Nord)
    filltherow(r,size-1)
    movetocorner(r)
    moveback(a,b,r)
end