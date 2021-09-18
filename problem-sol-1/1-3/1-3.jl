function moveback(countSud,countEast,r)
    for i=1:countSud
        move!(r,Sud)
    end
    for i=1:countEast
        move!(r,Ost)
    end
end
function movetoside(r, s)
    count=0
    while isborder(r,s)==false
        move!(r,s)
        count+=1
    end
    return count
end
function movetocorner(r)
    countNord=movetoside(r, HorizonSide(0))
    countWest=movetoside(r, HorizonSide(1))
    return countNord, countWest
end
function filltherow(r,s)
    while isborder(r,s)==false
        move!(r,s)
        putmarker!(r)
    end
end
function fillthefield(r)
    s=3
    while true
        putmarker!(r)
        filltherow(r,HorizonSide(s%4))
        if isborder(r,Sud)==true
            break
        else
            move!(r,Sud)
        s+=2
        end
    end
end
function fill(r)
    a,b=movetocorner(r)
    fillthefield(r)
    movetocorner(r)
    moveback(a,b,r)
end

