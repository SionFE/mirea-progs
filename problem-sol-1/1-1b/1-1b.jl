function reverse(side)
    return HorizonSide((Int(side)+2)%4)
end
function cross(r)
    for i in (HorizonSide(s) for s in 0:3)
        steps=0
        while isborder(r,i)==false
            move!(r,i)
            putmarker!(r)
            steps+=1
        end
        reversiv=reverse(i)
        for i2=1:steps
            move!(r,reversive)
        end
    end
    putmarker!(r)
end